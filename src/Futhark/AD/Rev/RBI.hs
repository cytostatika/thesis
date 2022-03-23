module Futhark.AD.Rev.RBI (diffPlusRBI, diffMulRBI, diffMinMaxRBI, diffGeneralRBI) where

import Control.Monad
import Futhark.AD.Rev.Monad
import Futhark.Analysis.PrimExp.Convert
import Futhark.Builder
import Futhark.IR.SOACS
import Futhark.Tools
import Futhark.Transform.Rename

diffGeneralRBI ::
  VjpOps ->
  Pat ->
  StmAux () ->
  (SubExp, [VName], Lambda) ->
  (Shape, SubExp, VName, SubExp, Lambda) ->
  ADM () ->
  ADM ()
diffGeneralRBI ops pat@(Pat [pe]) aux (n, arrs@([is, vs]), f) (w@(Shape [wsubexp]), rf, orig_dst, ne, lam) m = do
  iota_n <- letExp "iota_n" $ BasicOp $ Iota n (intConst Int64 0) (intConst Int64 1) Int64

  let bitType = int64
  let zeroSubExp = Constant $ IntValue $ intValue Int64 0
  let oneSubExp = Constant $ IntValue $ intValue Int64 1
  
  -- bits = map (\ind_x -> (ind_x >> digit_n) & 1) ind
  ind_x <- newParam "ind_x" $ Prim bitType
  digit_n <- letSubExp "zero_digit" $ zeroExp $ Prim bitType -- placeholder
  bits_map_bdy <- runBodyBuilder . localScope (scopeOfLParams [ind_x]) $ do
    eBody
     [
       eBinOp (And Int64)
         (eBinOp (LShr Int64) (eParam ind_x) (toExp digit_n))
         (eSubExp $ Constant $ IntValue $ intValue Int64 1)
     ]
  let bits_map_lam = Lambda [ind_x] bits_map_bdy [Prim bitType]
  bits <- letExp "bits" $ Op $ Screma n [vs] (ScremaForm [] [] bits_map_lam)
  
  -- let bits_inv = map (\b -> 1 - b) bits
  bit_x <- newParam "bit_x" $ Prim bitType
  bits_inv_map_bdy <- runBodyBuilder . localScope (scopeOfLParams [bit_x]) $ do
    eBody
     [
       eBinOp (Sub Int64 OverflowUndef)
        (eSubExp $ Constant $ IntValue $ intValue Int64 1)
        (eParam bit_x)
     ]
  let bits_inv_map_lam = Lambda [bit_x] bits_inv_map_bdy [Prim bitType]
  bits_inv <- letExp "bits_inv" $ Op $ Screma n [bits] (ScremaForm [] [] bits_inv_map_lam)

  -- let ps0 = scan (+) 0 (bits_inv)
    -- *** Generalize this part so we can use it twice without geting "bound twice" error
  ps0_x <- newParam "ps0_x" $ Prim bitType
  ps0_y <- newParam "ps0_y" $ Prim bitType
  ps0_scanlam_bdy <- runBodyBuilder . localScope (scopeOfLParams [ps0_x, ps0_y]) $ do
    eBody
     [
       eBinOp (Add Int64 OverflowUndef)
        (eParam ps0_x)
        (eParam ps0_y)
     ]
  let ps0_scanlam = Lambda [ps0_x, ps0_y] ps0_scanlam_bdy [Prim bitType]
  let ps0_scan = Scan ps0_scanlam [Constant $ IntValue $ intValue Int64 0]
    -- ***
  f' <- mkIdentityLambda [Prim bitType]
  ps0 <- letExp "ps0" $ Op $ Screma n [bits_inv] (ScremaForm [ps0_scan] [] f')

  -- let ps0_clean = map2 (*) bits_inv ps0 
  ps0clean_bitinv <- newParam "ps0clean_bitinv" $ Prim bitType
  ps0clean_ps0 <- newParam "ps0clean_ps0" $ Prim bitType
  ps0clean_lam_bdy <- runBodyBuilder . localScope (scopeOfLParams [ps0clean_bitinv, ps0clean_ps0]) $ do
    eBody
     [
       eBinOp (Mul Int64 OverflowUndef)
        (eParam ps0clean_bitinv)
        (eParam ps0clean_ps0)
     ]
  let ps0clean_lam = Lambda [ps0clean_bitinv, ps0clean_ps0] ps0clean_lam_bdy [Prim bitType]
  ps0clean <- letExp "ps0_clean" $ Op $ Screma n [bits_inv, ps0] (ScremaForm [] [] ps0clean_lam)

  -- let ps1 = scan (+) 0 bits
    -- *** Generalize this part so we can use it twice without geting "bound twice" error
  ps1_x <- newParam "ps1_x" $ Prim bitType
  ps1_y <- newParam "ps1_y" $ Prim bitType
  ps1_scanlam_bdy <- runBodyBuilder . localScope (scopeOfLParams [ps1_x, ps1_y]) $ do
    eBody
     [
       eBinOp (Add Int64 OverflowUndef)
        (eParam ps1_x)
        (eParam ps1_y)
     ]
  let ps1_scanlam = Lambda [ps1_x, ps1_y] ps1_scanlam_bdy [Prim bitType]
  let ps1_scan = Scan ps1_scanlam [Constant $ IntValue $ intValue Int64 0]
    -- ***
  f'' <- mkIdentityLambda [Prim bitType]
  ps1 <- letExp "ps1" $ Op $ Screma n [bits] (ScremaForm [ps1_scan] [] f'')


  -- let ps0_offset = reduce (+) 0 bits_inv
    -- *** Generalize this part so we can use it twice without geting "bound twice" error
  ps0off_x <- newParam "ps0off_x" $ Prim bitType
  ps0off_y <- newParam "ps0off_y" $ Prim bitType
  ps0off_redlam_bdy <- runBodyBuilder . localScope (scopeOfLParams [ps0off_x, ps0off_y]) $ do
    eBody
     [
       eBinOp (Add Int64 OverflowUndef)
        (eParam ps0off_x)
        (eParam ps0off_y)
     ]
  let ps0off_redlam = Lambda [ps0off_x, ps0off_y] ps0off_redlam_bdy [Prim bitType]
    -- ***
  ps0off_red <- reduceSOAC [Reduce Commutative ps0off_redlam [intConst Int64 0]]
  ps0off <- letExp "ps0off" $ Op $ Screma n [bits_inv] ps0off_red


  -- let ps1_clean = map (+ps0_offset) ps1
  ps1clean_x <- newParam "ps1clean_x" $ Prim bitType
  ps1clean_lam_bdy <- runBodyBuilder . localScope (scopeOfLParams [ps1clean_x]) $ do
    eBody
     [
       eBinOp (Add Int64 OverflowUndef)
        (eParam ps1clean_x)
        (eSubExp $ Var ps0off)
     ]
  let ps1clean_lam = Lambda [ps1clean_x] ps1clean_lam_bdy [Prim bitType]
  ps1clean <- letExp "ps1clean" $ Op $ Screma n [ps1] (ScremaForm [] [] ps1clean_lam)

  -- let ps0_clean = map2 (*) bits_inv ps0 
  ps1clean'_bit <- newParam "ps1cleanprim_bit" $ Prim bitType
  ps1clean'_ps1clean <- newParam "ps1cleanprim_ps1clean" $ Prim bitType
  ps1clean'_lam_bdy <- runBodyBuilder . localScope (scopeOfLParams [ps1clean'_bit, ps1clean'_ps1clean]) $ do
    eBody
     [
       eBinOp (Mul Int64 OverflowUndef)
        (eParam ps1clean'_bit)
        (eParam ps1clean'_ps1clean)
     ]
  let ps1clean'_lam = Lambda [ps1clean'_bit, ps1clean'_ps1clean] ps1clean'_lam_bdy [Prim bitType]
  ps1clean' <- letExp "ps1_cleanprim" $ Op $ Screma n [bits, ps1clean] (ScremaForm [] [] ps1clean'_lam)


  -- This part is just to let dev -s return something useful
  -- return the first w values in array ------- Change this vvv to the most recent expression
  last_sliced <- letExp "last_arr_sliced" $ BasicOp $ Index ps1clean' $ fullSlice (Prim bitType) [DimSlice zeroSubExp wsubexp (constant (1 :: Int64))]
  -- This gives zero atm, who cares it stays just because it will compile
  addStm $ Let pat aux $ BasicOp $ Index ps0 $ fullSlice (Prim bitType) [DimSlice zeroSubExp wsubexp (constant (1 :: Int64))]
  m
  -- Adjoint value is equal to sliced - allows me to sneakpeak at generated code
  insAdj orig_dst last_sliced


-- TODO
-- 1. Remove all unnecessary parameters and clean up code (better comments?)
-- 2. Support non identity lambdas for the histogram in vjpSOAC.
--     We need to unwrap it and then call the function it holds with is and vs to get the real values 
-- 3. Explain the pseudocode and the implemented code in the report
-- 4. Read through all aux functions and remove unneccessary parts
diffPlusRBI ::
  VjpOps ->
  Pat ->
  StmAux () ->
  (SubExp, [VName], Lambda) ->
  (Shape, SubExp, VName, SubExp, Lambda) ->
  ADM () ->
  ADM ()
diffPlusRBI ops pat@(Pat [pe]) aux (n, arrs@([is, vs]), f) (w, rf, orig_dst, ne, add_lam) m = do

  -- Forward pass with copy of orig_dst, backwards will need the original.
  dst_cpy <- letExp (baseString orig_dst ++ "_copy") $ BasicOp $ Copy orig_dst
  let histo' = Hist n arrs [HistOp w rf [dst_cpy] [ne] add_lam] f 
  addStm $ Let pat aux $ Op histo'

  m
  
  -- Backward pass
  let eltp = head $ lambdaReturnType add_lam
  -- already update orig_dst bar
  hist_bar <- lookupAdjVal $ patElemName pe
  updateAdj orig_dst hist_bar
  -- update the vs bar; create a map nest with the branch innermost so all
  -- parallelism can be exploited.
  pind <- newParam "ind" (Prim $ IntType Int64)
  map_bar_lam_bdy <- genIdxLamBdy hist_bar [(w, pind)] eltp
  let map_bar_lam = Lambda [pind] map_bar_lam_bdy [eltp]
  vs_bar_contrib <- letExp (baseString vs ++ "_bar") $ Op $ Screma n [is] (ScremaForm [] [] map_bar_lam)
  void $ updateAdj vs vs_bar_contrib
  
  
diffMulRBI ::
  VjpOps ->
  Pat ->
  StmAux () ->
  (SubExp, [VName], Lambda) ->
  (Shape, SubExp, VName, SubExp, Lambda, BinOp) ->
  ADM () ->
  ADM ()
diffMulRBI ops pat@(Pat [pe]) aux (n, arrs@([is, vs]), f) (w@(Shape [wsubexp]), rf, orig_dst, ne, mul_lam, mulOp) m = do

  let t = binOpType mulOp
  t_zero <- letSubExp "t_zero" $ zeroExp $ Prim t
  t_one <- letSubExp "t_one" $ oneExp $ Prim t
  
  ------  FORWARD  ------

  -- Zero count map function
  -- map (\v_f -> if v_f==0 then 1 else 0)
  v_f <- newParam "v_f" $ Prim t
  zero_map_lam_bdy <- runBodyBuilder . localScope (scopeOfLParams [v_f]) $ do
    eBody
     [eIf
          (eCmpOp (CmpEq t) (eParam v_f) (toExp t_zero))
          ( eBody
              [ eSubExp (Constant $ IntValue $ intValue Int64 1)
              ]
          )
          ( eBody
              [ eSubExp (Constant $ IntValue $ intValue Int64 0)
              ]
          )
     ]
  let zero_map_lam = Lambda [v_f] zero_map_lam_bdy [Prim int64]
  vs_zeros_indicator <- letExp "zero_indicator" $ Op $ Screma n [vs] (ScremaForm [] [] zero_map_lam)

  -- Nonzero product map function
  -- map (\v_f -> if v_f==0 then 1 else a)
  v_f2 <- newParam "v_f2" $ Prim t
  nzp_map_lam_bdy <- runBodyBuilder . localScope (scopeOfLParams [v_f2]) $ do
    eBody
     [eIf
          (eCmpOp (CmpEq t) (eParam v_f2) (toExp t_zero))
          ( eBody
              [ toExp t_one
              ]
          )
          ( eBody
              [ eParam v_f2
              ]
          )
     ]
  let nzp_map_lam = Lambda [v_f2] nzp_map_lam_bdy [Prim t]
  vs_nonzeros <- letExp "nonzero_values" $ Op $ Screma n [vs] (ScremaForm [] [] nzp_map_lam)
  
-- Everything above should be fine
  zr_counts0 <- letExp "zr_cts" $ BasicOp $ Replicate (w) (intConst Int64 0)
  nz_prods0 <- letExp "nz_prd" $ BasicOp $ Replicate (w) ne
  nz_prods <- newVName "non_zero_prod"
  zr_counts <- newVName "zero_count"
  
  -- Lambda to add int64 (zero counts)
  a <- newParam "a" $ Prim int64
  b <- newParam "b" $ Prim int64
  let addop = Add Int64 OverflowUndef
  lam_bdy <- runBodyBuilder . localScope (scopeOfLParams [a,b]) $ do
    r <- letSubExp "r" $ BasicOp $ BinOp addop (Var $ paramName a) (Var $ paramName b)
    resultBodyM [r]
  lam_add_int64 <- return $ Lambda [a,b] lam_bdy [Prim $ IntType Int64]
  let hist_zrn = HistOp w rf [zr_counts0] [intConst Int64 0] lam_add_int64
  let hist_nzp = HistOp w rf [nz_prods0] [ne] mul_lam
  f' <- mkIdentityLambda [Prim $ IntType Int64, Prim $ IntType Int64, Prim t, Prim $ IntType Int64]
  let pe_tp = patElemDec pe
  
  let soac_pat =
          Pat
            [ PatElem nz_prods pe_tp,
              PatElem zr_counts $
             Array (int64) w NoUniqueness 
            ]
  let soac_exp = Op $ Hist n [is, is, vs_nonzeros, vs_zeros_indicator] [hist_nzp, hist_zrn] f' 
  auxing aux $ letBind soac_pat soac_exp

  -- Create final result
  -- map2 (\nzp zc -> if (zc > 0) then 0 else nzp) vs_nzprod zero_counts
  result <- newVName "res_part"
  pstuple <- zipWithM newParam ["nz_pr", "zr_ct"] [Prim t, Prim int64]
  let [nz_prod, zr_count] = map paramName pstuple

  let ps = [Param mempty nz_prod $ Prim t, Param mempty zr_count $ Prim int64]
  if_stm <- runBuilder_ . localScope (scopeOfLParams ps) $ do
    tmps <-
      letTupExp "tmp_if_res"
        =<< eIf
          (toExp $ le64 zr_count .>. pe64 (intConst Int64 0))
          (resultBodyM [Constant $ blankPrimValue t])
          (resultBodyM [Var nz_prod])
    addStm (mkLet [Ident result $ Prim t] $ BasicOp $ SubExp $ Var $ head tmps)

  lam_bdy_2 <- runBodyBuilder . localScope (scopeOfLParams pstuple) $ do
      addStms if_stm
      resultBodyM [Var result]

  h_part <-
      letExp "hist_part" $
        Op $
          Screma
            wsubexp -- Size??
            [nz_prods, zr_counts]
            (ScremaForm [] [] (Lambda pstuple lam_bdy_2 [Prim t]))

  ps3 <- zipWithM newParam ["h_orig", "h_part"] [Prim t, Prim t]
  let [ph_orig, ph_part] = map paramName ps3
  lam_pe_bdy <- runBodyBuilder . localScope (scopeOfLParams ps3) $ do
      r <- letSubExp "res" $ BasicOp $ BinOp mulOp (Var ph_orig) (Var ph_part)
      resultBodyM [r]
  auxing aux $
      letBind (Pat [pe]) $
        Op $
          Screma
            wsubexp
            [orig_dst, h_part]
            (ScremaForm [] [] (Lambda ps3 lam_pe_bdy [Prim t]))

  m

  -- reverse trace
  pe_bar <- lookupAdjVal $ patElemName pe
  -- updates the orig_dst with its proper bar
  mul_lam' <- renameLambda mul_lam
  orig_bar <-
    letTupExp (baseString orig_dst ++ "_bar") $
      Op $
        Screma
          wsubexp
          [h_part, pe_bar]
          (ScremaForm [] [] mul_lam')
  zipWithM_ updateAdj [orig_dst] orig_bar


 -- updates the partial histo result with its proper bar
  mul_lam'' <- renameLambda mul_lam
  part_bars <-
    letTupExp (baseString h_part ++ "_bar") $
      Op $
        Screma
          wsubexp
          [orig_dst, pe_bar]
          (ScremaForm [] [] mul_lam'')
          
  let [part_bar] = part_bars
  --   -- add the contributions to each array element
  pj <- newParam "j" $ Prim int64
  v_b <- newParam "v" $ Prim t
  let j = paramName pj
  ((zr_cts, pr_bar, nz_prd), tmp_stms) <- runBuilderT' . localScope (scopeOfLParams [pj, v_b]) $ do
    zr_cts <- letExp "zr_cts" $ BasicOp $ Index zr_counts $ fullSlice (Prim t) [DimFix (Var j)] -- : fullSlice (Prim t) []
    pr_bar <- letExp "pr_bar" $ BasicOp $ Index part_bar $ fullSlice (Prim t) [DimFix (Var j)] -- : fullSlice (Prim t) []
    nz_prd <- letExp "nz_prd" $ BasicOp $ Index nz_prods $ fullSlice (Prim t) [DimFix (Var j)]
    return (zr_cts, pr_bar, nz_prd)

  let params = zipWith (Param mempty) [nz_prd, zr_cts, pr_bar] [Prim t, Prim int64, Prim t]

  bdy_tmp <- runBodyBuilder . localScope (scopeOfLParams (v_b : params) ) $ do
    eBody 
      [ eIf
          (eCmpOp (CmpEq $ IntType Int64) (eSubExp $ Var zr_cts) (eSubExp (Constant $ IntValue $ intValue Int64 0)) )
          ( eBody
            [ eBinOp mulOp (eBinOp (getBinOpDiv mulOp) (eSubExp $ Var nz_prd) (eParam v_b)) (eSubExp $ Var pr_bar)]
            
          )
          ( eBody
            [ eIf 
                ( eBinOp LogAnd
                    (eCmpOp (CmpEq t) (eParam v_b) (toExp t_zero))
                    (eCmpOp (CmpEq $ IntType Int64) (eSubExp $ Var zr_cts) (eSubExp (Constant $ IntValue $ intValue Int64 1)) )
                )
                (eBody
                  [eBinOp mulOp (eSubExp $ Var nz_prd) (eSubExp $ Var pr_bar)]
                )
                (eBody
                  [ eSubExp (Constant $ blankPrimValue t)]
                )
            ]
          )
      ]
  lam_bar <-
    runBodyBuilder . localScope (scopeOfLParams [pj, v_b]) $
      eBody
        [ eIf
            (toExp $ withinBounds [(w, j)])
            ( do
                addStms (tmp_stms <> bodyStms bdy_tmp)
                resultBodyM $ map resSubExp (bodyResult bdy_tmp)
            )
            (resultBodyM [Constant $ blankPrimValue t])
        ]
  vs_bar <-
    letTupExp (baseString vs ++ "_bar") $
      Op $
        Screma
          n
          [is, vs]
          (ScremaForm [] [] (Lambda [pj, v_b] lam_bar [Prim t]))
          
  zipWithM_ updateAdj [vs] vs_bar      
  m

  where
    getBinOpDiv (Mul t _) = SDiv t Unsafe
    getBinOpDiv (FMul t) = FDiv t
    getBinOpDiv _ = error "RBIDiffMul: BinOp is not multiplication."

diffMinMaxRBI ::
  VjpOps ->
  Pat ->
  StmAux () ->
  (SubExp, [VName], Lambda) ->
  (Shape, SubExp, VName, SubExp, Lambda, BinOp) ->
  ADM () ->
  ADM ()
diffMinMaxRBI ops pat@(Pat [pe]) aux (n, arrs@([is, vs]), f) (w@(Shape [wsubexp]), rf, orig_dst, ne, mul_lam, bop) m = do

  let t = binOpType bop
  let ptp = Prim t
  let negOne = intConst Int64 (-1)

  -- *** Forward Pass ***
  orig_dst_cpy <- letExp (baseString orig_dst ++ "_cpy") $ BasicOp $ Copy orig_dst
  f' <- mkIdentityLambda [Prim int64, Prim t, Prim int64]
  repl <- letExp "minus_ones" $ BasicOp $ Replicate w negOne
  
  -- minMaxIndLam = (\ acc_v acc_i v i ->
  --   if (acc_v == v) then (acc_v, min acc_i i)  -- Earliest index 
  --       else if (acc_v == minmax acc_v v)
  --            then (acc_v, acc_i)
  --            else (v, i)
  --  )
  minMaxIndLam <- mkMinMaxIndLam t bop

  -- let (pe, hist_inds) = reduce_by_index (copy orig_dest) max_ind_op (ne,-1) is (zip vs (iota n))
  let hist_op = HistOp w rf [orig_dst_cpy, repl] [ne, negOne] minMaxIndLam
  iota_n <- letExp "iota_n" $ BasicOp $ Iota n (intConst Int64 0) (intConst Int64 1) Int64
  hist_inds <- newVName "hist_inds"
  let histo_pat = Pat [pe, PatElem hist_inds $ Array (int64) w NoUniqueness]

  auxing aux $ letBind histo_pat $ Op $ Hist n [is, vs, iota_n] [hist_op] f' 

  m 



  -- *** Backwards Pass ***

  pe_bar <- lookupAdjVal $ patElemName pe

  -- create the bar of `orig_dst` by means of a map:
  -- dst_bar <- map (\min_ind el -> if min_ind == -1 then el else 0) hist_inds pe_bar 
  pis_h <- zipWithM newParam ["min_ind", "h_elem"] [Prim int64, Prim t]
  let [min_ind, el] = map paramName pis_h
  lam_bdy_dst_bar <-
    runBodyBuilder . localScope (scopeOfLParams pis_h) $
      eBody
        [ eIf
            (toExp $ mind_eq_min1 min_ind)
            (resultBodyM [Var el])
            (resultBodyM [Constant $ blankPrimValue t])
        ]
  let lam_dst_bar = Lambda pis_h lam_bdy_dst_bar [Prim t]
  dst_bar <-
    letExp (baseString orig_dst ++ "_bar") $
      Op $
        Screma wsubexp [hist_inds, pe_bar] (ScremaForm [] [] lam_dst_bar) 

  insAdj orig_dst dst_bar

  -- vs_contrib <- 
  --   map2 (\ i h_v -> if i == -1
  --              then 0
  --              else vs_bar[i] + h_v
  --    ) histo_inds histo_bar
  vs_bar <- lookupAdjVal vs
  pis_v <- zipWithM newParam ["min_ind", "h_elem"] [Prim int64, Prim t]
  let [min_ind_v, h_elem_v] = map paramName pis_v
  lam_bdy_vs_bar <-
    runBodyBuilder . localScope (scopeOfLParams pis_v) $
      eBody
        [ eIf
            (toExp $ mind_eq_min1 min_ind_v)
            (resultBodyM [Constant $ blankPrimValue t])
            ( do
                vs_bar_i <-
                  letSubExp (baseString vs_bar ++ "_el") $
                    BasicOp $ 
                      Index vs_bar $ fullSlice (Prim t) [DimFix $ Var min_ind_v]
                let plus_op = getBinOpPlus t
                r <- letSubExp "r" $ BasicOp $ BinOp plus_op vs_bar_i $ Var h_elem_v
                resultBodyM [r]
            )
        ]
  let lam_vs_bar = Lambda pis_v lam_bdy_vs_bar [Prim t]
  vs_contrib <-
    letExp (baseString vs_bar ++ "_partial") $
      Op $
        Screma wsubexp [hist_inds, pe_bar] (ScremaForm [] [] lam_vs_bar) 

  -- scatter vs_bar hist_inds vs_contrib
  f'' <- mkIdentityLambda [Prim int64, Prim t]
  let scatter_soac = Scatter wsubexp [hist_inds, vs_contrib] f'' [(Shape [n], 1, vs_bar)]
  vs_bar' <- letExp (baseString vs ++ "_bar") $ Op scatter_soac
  insAdj vs vs_bar'

  where
    mkI64ArrType len = Array int64 (Shape [len]) NoUniqueness

getBinOpPlus :: PrimType -> BinOp
getBinOpPlus (IntType x) = Add x OverflowUndef
getBinOpPlus (FloatType f) = FAdd f
getBinOpPlus _ = error "In getBinOpMul, Rev.hs: input Cert not supported"

-- generates the lambda for the extended operator of min/max:
-- meaning the min/max value tupled with the minimal index where
--   that value was found (when duplicates exist). We use `-1` as
--   the neutral element of the index.
mkMinMaxIndLam :: PrimType -> BinOp -> ADM Lambda
mkMinMaxIndLam t minmax_op = do
  fargs_vals <- mapM (`newParam` Prim t) ["acc_v", "arg_v"]
  fargs_inds <- mapM (`newParam` Prim int64) ["acc_ind", "arg_ind"]
  let ([facc_v, farg_v], [facc_i, farg_i]) = (fargs_vals, fargs_inds)
  let [acc_v, arg_v, acc_i, arg_i] = map paramName (fargs_vals ++ fargs_inds)
  let (cmp1, cmp2) = get_cmp_pexp minmax_op acc_v arg_v
  red_lam_bdy <-
    runBodyBuilder . localScope (scopeOfLParams (fargs_vals ++ fargs_inds)) $
      eBody
        [ eIf
            (toExp cmp1)
            ( do
                res_ind <- letSubExp "minmax" =<< toExp (min_idx_pexp acc_i arg_i)
                resultBodyM [Var acc_v, res_ind]
            )
            ( eBody
                [ eIf
                    (toExp cmp2)
                    (resultBodyM [Var acc_v, Var acc_i])
                    (resultBodyM [Var arg_v, Var arg_i])
                ]
            )
        ]
  return $ Lambda [facc_v, facc_i, farg_v, farg_i] red_lam_bdy [Prim t, Prim int64]
  where
    min_idx_pexp i1 i2 = BinOpExp (SMin Int64) (LeafExp i1 int64) (LeafExp i2 int64)
    get_cmp_pexp bop facc farg =
      let [leaf_acc, leaf_arg] = map (`LeafExp` t) [facc, farg]
       in ( CmpOpExp (CmpEq t) leaf_acc leaf_arg,
            CmpOpExp (CmpEq t) leaf_acc $ BinOpExp bop leaf_acc leaf_arg
          )
  

-- Generates: `ind == -1`
mind_eq_min1 :: VName -> PrimExp VName
mind_eq_min1 ind =
  CmpOpExp
    (CmpEq (IntType Int64))
    (LeafExp ind int64)
    (ValueExp (IntValue $ Int64Value (-1)))

-- Generates a potential tower-of-maps lambda body for an indexing operation.
-- Assuming parameters:
--   `arr`   the array that is indexed
--   `[(w_1, i_1), (w_2, i_2), ..., (w_k, i_k)]` outer lambda formal parameters and their bounds
--   `[n_1,n_2,...]ptp` the type of the index expression `arr[i_1,i_2,...,i_k]`
-- Generates something like:
-- (\ i_1 i_2 ->
--    map (\j_1 -> ... if (i_1 >= 0 && i_1 < w_1) &&
--                        (i_2 >= 0 && i_2 < w_2) && ...
--                     then arr[i_1, i_2, ... j_1, ...]
--                     else 0
--        ) (iota n_1)
-- )
-- The idea is that you do not want to put under the `if` something
--     that is an array because it would not flatten well!
genIdxLamBdy :: VName -> [(Shape, Param Type)] -> Type -> ADM Body
genIdxLamBdy as wpis = genRecLamBdy as wpis []
  where
    genRecLamBdy :: VName -> [(Shape, Param Type)] -> [Param Type] -> Type -> ADM Body
    genRecLamBdy arr w_pis nest_pis (Array t (Shape []) _) =
      genRecLamBdy arr w_pis nest_pis (Prim t)
    genRecLamBdy arr w_pis nest_pis (Array t (Shape (s : ss)) u) = do
      new_ip <- newParam "i" (Prim $ IntType Int64)
      let t' = if null ss then Prim t else (Array t (Shape ss) u)
      inner_lam_bdy <- genRecLamBdy arr w_pis (nest_pis ++ [new_ip]) t'
      let inner_lam = Lambda [new_ip] inner_lam_bdy [t']
          (_, orig_pis) = unzip w_pis
      (r, stms) <- runBuilderT' . localScope (scopeOfLParams (orig_pis ++ nest_pis)) $ do
        iota_v <- letExp "iota" $ BasicOp $ Iota s (intConst Int64 0) (intConst Int64 1) Int64
        letSubExp (baseString arr ++ "_elem") $ Op $ Screma s [iota_v] (ScremaForm [] [] inner_lam) 
      mkBodyM stms [subExpRes r]
    genRecLamBdy arr w_pis nest_pis (Prim ptp) = do
      let (ws, orig_pis) = unzip w_pis
      let inds = map paramName (orig_pis ++ nest_pis)
      runBodyBuilder . localScope (scopeOfLParams (orig_pis ++ nest_pis)) $
        eBody
          [ eIf
              (toExp $ withinBounds $ zip ws $ map paramName orig_pis)
              ( do
                  r <- letSubExp "r" $ BasicOp $ Index arr $ Slice $ map (DimFix . Var) inds
                  resultBodyM [r]
              )
              (resultBodyM [Constant $ blankPrimValue ptp])
          ]
    genRecLamBdy _ _ _ _ = error "In Rev.hs, helper function genRecLamBdy, unreachable case reached!"



withinBounds :: [(Shape, VName)] -> TPrimExp Bool VName
withinBounds [] = TPrimExp $ ValueExp (BoolValue True)
withinBounds [(q, i)] = (le64 i .<. pe64 (shapeSize 0 q)) .&&. (pe64 (intConst Int64 (-1)) .<. le64 i)
withinBounds (qi : qis) = withinBounds [qi] .&&. withinBounds qis