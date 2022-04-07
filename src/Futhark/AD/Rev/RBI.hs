module Futhark.AD.Rev.RBI (diffPlusRBI, diffMulRBI, diffMinMaxRBI, diffGeneralRBI) where

import Control.Monad
import Futhark.AD.Rev.Monad
import Futhark.Analysis.PrimExp.Convert
import Futhark.Builder
import Futhark.IR.SOACS
import Futhark.Tools
import Futhark.Transform.Rename

eReverse :: MonadBuilder m => VName -> m VName
eReverse arr = do
  arr_t <- lookupType arr
  let w = arraySize 0 arr_t
  start <-
    letSubExp "rev_start" $
      BasicOp $ BinOp (Sub Int64 OverflowUndef) w (intConst Int64 1)
  let stride = intConst Int64 (-1)
      slice = fullSlice arr_t [DimSlice start w stride]
  letExp (baseString arr <> "_rev") $ BasicOp $ Index arr slice

-- partion2Maker - Takes flag array and values and creates a scatter SOAC
--                  which corresponds to the partition2 of the inputs
-- partition2Maker size flags values = 
partition2Maker :: SubExp -> VName -> VName -> BuilderT SOACS ADM (SOAC SOACS)
partition2Maker n bits xs = do
 
  let bitType = int64
  let zeroSubExp = Constant $ IntValue $ intValue Int64 (0 :: Integer)
  let oneSubExp = Constant $ IntValue $ intValue Int64 (1 :: Integer)

  -- let bits_inv = map (\b -> 1 - b) bits
  bit_x <- newParam "bit_x" $ Prim bitType
  bits_inv_map_bdy <- runBodyBuilder . localScope (scopeOfLParams [bit_x]) $ do
    eBody
     [
       eBinOp (Sub Int64 OverflowUndef)
        (eSubExp $ oneSubExp)
        (eParam bit_x)
     ]
  let bits_inv_map_lam = Lambda [bit_x] bits_inv_map_bdy [Prim bitType]
  bits_inv <- letExp "bits_inv" $ Op $ Screma n [bits] (ScremaForm [] [] bits_inv_map_lam)

  -- let ps0 = scan (+) 0 (bits_inv)
  ps0_add_lam <- binOpLambda (Add Int64 OverflowUndef) bitType
  let ps0_add_scan = Scan ps0_add_lam [zeroSubExp]
  f' <- mkIdentityLambda [Prim bitType]
  ps0 <- letExp "ps0" $ Op $ Screma n [bits_inv] (ScremaForm [ps0_add_scan] [] f')

  -- let ps0_clean = map2 (*) bits_inv ps0 
  ps0clean_mul_lam <- binOpLambda (Mul Int64 OverflowUndef) bitType
  ps0clean <- letExp "ps0_clean" $ Op $ Screma n [bits_inv, ps0] (ScremaForm [] [] ps0clean_mul_lam)

  -- let ps1 = scan (+) 0 bits
  ps1_scanlam <- binOpLambda (Add Int64 OverflowUndef) bitType
  let ps1_scan = Scan ps1_scanlam [zeroSubExp]
  f'' <- mkIdentityLambda [Prim bitType]
  ps1 <- letExp "ps1" $ Op $ Screma n [bits] (ScremaForm [ps1_scan] [] f'')


  -- let ps0_offset = reduce (+) 0 bits_inv    
  ps0off_add_lam <- binOpLambda (Add Int64 OverflowUndef) bitType
  ps0off_red <- reduceSOAC [Reduce Commutative ps0off_add_lam [intConst Int64 0]]
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
  ps1cleanprim_mul_lam <- binOpLambda (Mul Int64 OverflowUndef) bitType
  ps1clean' <- letExp "ps1_cleanprim" $ Op $ Screma n [bits, ps1clean] (ScremaForm [] [] ps1cleanprim_mul_lam)

  -- let ps = map2 (+) ps0_clean ps1_clean'
  ps_add_lam <- binOpLambda (Add Int64 OverflowUndef) bitType
  ps <- letExp "ps" $ Op $ Screma n [ps0clean, ps1clean'] (ScremaForm [] [] ps_add_lam)


  -- let ps_actual = map (-1) ps
  psactual_x <- newParam "psactual_x" $ Prim bitType
  psactual_lam_bdy <- runBodyBuilder . localScope (scopeOfLParams [psactual_x]) $ do
    eBody
     [
       eBinOp (Sub Int64 OverflowUndef)
        (eParam psactual_x)
        (eSubExp $ oneSubExp)
     ]
  let psactual_lam = Lambda [psactual_x] psactual_lam_bdy [Prim bitType]
  psactual <- letExp "psactual" $ Op $ Screma n [ps] (ScremaForm [] [] psactual_lam)
  
  -- let scatter_inds = scatter inds ps_actual inds
  -- return scatter_inds
  f''' <- mkIdentityLambda [Prim int64, Prim int64]
  xs_cpy <- letExp (baseString xs ++ "_copy") $ BasicOp $ Copy xs
  return $ Scatter n [psactual, xs] f''' [(Shape [n], 1, xs_cpy)]


-- scan (\(v1,f1) (v2,f2) ->
--            let f = f1 || f2
--            let v = if f2 then ne else op v1 v2
--            in (v, f))

-- Lift a lambda to produce an exlusive segmented scan operator.
mkSegScanExc :: Lambda -> [SubExp] -> SubExp -> VName -> VName -> ADM (SOAC SOACS) 
mkSegScanExc lam ne n vals flags = do
  -- Get lambda return type
  let rt = lambdaReturnType lam
  -- v <- mapM (newParam "v") rt
  v1 <- mapM (newParam "v1") rt
  v2 <- mapM (newParam "v2") rt
  f1 <- newParam "f1" $ Prim int8
  f2 <- newParam "f2" $ Prim int8
  let params = (f1 : v1) ++ (f2 : v2)

  lam' <- renameLambda lam
  -- let lam_body = lambdaBody lam'


  scan_body <- runBodyBuilder . localScope (scopeOfLParams params) $ do
    -- f = f1 || f2
    f <- letSubExp "f" $ BasicOp $ BinOp (Or Int8 ) (Var $ paramName f1) (Var $ paramName f2)

    -- let orig_lam_params = map paramName (lambdaParams lam')
    -- let new_lam_params = map Var $ map paramName (v1 ++ v2)
    -- letBindNames orig_lam_params $ BasicOp $ SubExp new_lam_params
    -- v = if f2 then ne else (lam v1 v2)     
    f_check <- letExp "f_check" $ BasicOp $ CmpOp (CmpEq $ IntType Int8) (Var $ paramName f2) (intConst Int8 0)
    ne_body <- eBody $ map eSubExp ne

    lam_body2 <- mkLambda (v1++v2) $ do
      eLambda lam' (map (eSubExp . Var . paramName) (v1++v2))


    v <- letSubExp "v" $
          If (Var f_check)
          ne_body
          (lambdaBody lam_body2)
          (IfDec (staticShapes rt) IfNormal)
    
    -- Put together
    eBody $ map eSubExp ([f, v])

  let scan_lambda = Lambda params scan_body (Prim int8 : rt)
  -- let map_lambda  = Lambda (v1++v2) (lambdaBody lam) rt
  idx_lam <- mkIdentityLambda ((Prim int8) : rt)
  -- scan_soac <- scanSOAC [Scan scan_lambda [ne, intConst Int64 0]]
  return $ Screma n [flags, vals] $ ScremaForm [Scan scan_lambda ((intConst Int8 0) : ne)] [] idx_lam

diffGeneralRBI ::
  Pat ->
  StmAux () ->
  (SubExp, [VName]) ->
  (Shape, [SubExp], VName, Lambda) ->
  ADM () ->
  ADM ()
diffGeneralRBI pat aux (n, [inds, vs]) (Shape [wsubexp],nes, orig_dst, f) m = do
  let bitType = int64
  let zeroSubExp = Constant $ IntValue $ intValue Int64 (0 :: Integer)
  let oneSubExp = Constant $ IntValue $ intValue Int64 (1 :: Integer)
  let negOneSubExp = Constant $ IntValue $ intValue Int64 ((-1) :: Integer)
  

-- flags = map (\ind -> ind < 0 then 0 else (if histDim < ind then 0 else 1)) inds
  ind_param <- newParam "ind" $ Prim int64
  pred_body <- runBodyBuilder . localScope (scopeOfLParams [ind_param]) $
    eBody
      [ eIf -- if ind < 0 then 0
        (eCmpOp (CmpSlt Int64) (eParam ind_param) (eSubExp zeroSubExp)  )
        (eBody [eSubExp zeroSubExp])
        (eBody
          [
            eIf -- if histDim < ind then 0 else 1
            (eCmpOp (CmpSlt Int64) (eSubExp wsubexp) (eParam ind_param) )
            (eBody [eSubExp zeroSubExp])
            (eBody [eSubExp oneSubExp])
          ])
      ]
  let pred_lambda = Lambda [ind_param] pred_body [Prim int64]
  flags <- letExp "flags" $ Op $ Screma n [inds] $ ScremaForm [][] pred_lambda

  -- flag_scanned = scan (+) 0 flags
  add_lambda_i64 <- addLambda (Prim int64)
  scan_soac <- scanSOAC [Scan add_lambda_i64 [zeroSubExp]]
  flags_scanned <- letExp "flag_scanned" $ Op $ Screma n [flags] scan_soac

  -- n' = last flags_scanned
  lastElem <- letSubExp "lastElem" $ BasicOp $ BinOp (Sub Int64 OverflowUndef) n oneSubExp
  n' <- letSubExp "new_length" $ BasicOp $ Index flags_scanned (fullSlice (Prim int64) [DimFix lastElem])

  -- new_inds = map (\(flag, flag_scan) -> if flag == 1 then flag_scan - 1 else -1) flags flag_scanned
  flag <- newParam "flag" $ Prim int64
  flag_scan <- newParam "flag_scan" $ Prim int64
  new_inds_body <- runBodyBuilder . localScope (scopeOfLParams [flag, flag_scan]) $
    eBody
    [ eIf
      (eCmpOp (CmpEq int64) (eParam flag) (eSubExp oneSubExp))
      (eBody [eBinOp (Sub Int64 OverflowUndef) (eSubExp $ Var $ paramName flag_scan) (eSubExp oneSubExp)])
      (eBody [eSubExp negOneSubExp])
    ]
  let new_inds_lambda = Lambda [flag, flag_scan] new_inds_body [Prim int64]
  new_inds <- letExp "new_inds" $ Op $ Screma n [flags, flags_scanned] $ ScremaForm [][] new_inds_lambda
      
  -- new_indexes = scatter (Scratch int n') new_inds (iota n)     
  f' <- mkIdentityLambda [Prim int64, Prim int64]
  orig_indexes_iota <- letExp "orig_indexes_iota" $ BasicOp $ Iota n zeroSubExp oneSubExp Int64
  indexes_dst <- letExp "indexes_dst" $ BasicOp $ Scratch int64 [n']
  new_indexes <- letExp "new_indexes" $ Op $ Scatter n [new_inds, orig_indexes_iota] f' [(Shape [n'], 1, indexes_dst)]

  -- new_bins = map (\i -> inds[i]) new_indexes
  i <- newParam "i" $ Prim int64
  new_bins_body <- runBodyBuilder . localScope (scopeOfLParams [i]) $ do
    body <- letSubExp "body" $ BasicOp $ Index inds (fullSlice (Prim int64) [DimFix (Var (paramName i))])     
    resultBodyM [body]
  let new_bins_lambda = Lambda [i] new_bins_body [Prim int64]
  new_bins <- letExp "new_bins" $ Op $ Screma n' [new_indexes] $ ScremaForm [][] new_bins_lambda


  -- [sorted_is, sorted_bins] = 
  --   loop over [new_indexes, new_bins] for i < 6 do 
  --     bits = map (\ind_x -> (ind_x >> i) & 1) new_bins
  --     newidx = partition2 bits (iota n')
  --     [map(\i -> new_indexes[i]) newidx, map(\i -> new_bins[i]) newidx]
  i2 <- newVName "i2"

  indexesForLoop <- newVName "new_indexes_rebound"
  new_indexes_cpy <- letExp (baseString new_indexes ++ "_copyLoop") $ BasicOp $ Copy new_indexes
  new_indexes_type <- lookupType new_indexes
  let isDeclTypeInds = toDecl new_indexes_type Unique
  let paramIndexes = Param mempty indexesForLoop isDeclTypeInds
  
  binsForLoop <- newVName "new_bins_rebound"
  new_bins_cpy <- letExp (baseString new_bins ++ "_copyLoop") $ BasicOp $ Copy new_bins
  new_bins_type <- lookupType new_bins
  let isDeclTypeBins = toDecl new_bins_type Unique
  let paramBins = Param mempty binsForLoop isDeclTypeBins
  
  let loop_vars = [(paramIndexes, Var new_indexes_cpy),(paramBins, Var new_bins_cpy)]
  
  -- bound = log2ceiling(w) (inner hist size aka number of bins)
  let bound = Constant $ IntValue $ intValue Int64 (6::Integer)

  ((idxres, binsres), stms) <- runBuilderT' . localScope (scopeOfFParams [paramIndexes, paramBins]) $ do
    -- bits = map (\ind_x -> (ind_x >> digit_n) & 1) ind
    ind_x <- newParam "ind_x" $ Prim bitType
    bits_map_bdy <- runBodyBuilder . localScope (scopeOfLParams [ind_x]) $
      eBody
      [
        eBinOp (And Int64)
          (eBinOp (LShr Int64) (eParam ind_x) (eSubExp $ Var i2))
          (eSubExp $ oneSubExp)
      ]
    let bits_map_lam = Lambda [ind_x] bits_map_bdy [Prim bitType]
    bits <- letExp "bits" $ Op $ Screma n' [binsForLoop] (ScremaForm [] [] bits_map_lam)

    -- Partition iota to get the new indices to scatter bins and inds by
    temp_iota <- letExp "temp_iota" $ BasicOp $ Iota n' zeroSubExp oneSubExp Int64
    scatter_soac <- partition2Maker n' bits temp_iota
    partitionedidx <- letExp (baseString inds ++ "_scattered") $ Op $ scatter_soac

    inner_indx_idx <- newParam "inner_indexes_idx" $ Prim int64
    inner_indx_bdy <- runBodyBuilder . localScope (scopeOfLParams [inner_indx_idx]) $ do
      tmp <- letSubExp "indexes_body" $ BasicOp $ Index (paramName paramIndexes) (fullSlice (Prim int64) [DimFix (Var (paramName inner_indx_idx))])
      resultBodyM [tmp]
    let inner_indx_lambda = Lambda [inner_indx_idx] inner_indx_bdy [Prim int64]
    inner_new_indexes <- letSubExp "new_indexes" $ Op $ Screma n' [partitionedidx] $ ScremaForm [][] inner_indx_lambda

    inner_bins_idx <- newParam "inner_indexes_idx" $ Prim int64
    inner_bins_bdy <- runBodyBuilder . localScope (scopeOfLParams [inner_bins_idx]) $ do
      tmp <- letSubExp "indexes_body" $ BasicOp $ Index (paramName paramBins) (fullSlice (Prim int64) [DimFix (Var (paramName inner_bins_idx))])
      resultBodyM [tmp]
    let inner_bins_lambda = Lambda [inner_bins_idx] inner_bins_bdy [Prim int64]
    inner_new_bins <- letSubExp "new_bins" $ Op $ Screma n' [partitionedidx] $ ScremaForm [][] inner_bins_lambda

    return (inner_new_indexes, inner_new_bins)

  loop_bdy <- mkBodyM stms [subExpRes idxres,subExpRes binsres]
  loop_res <- letTupExp "sorted_is_bins" $ DoLoop loop_vars (ForLoop i2 Int64 bound []) loop_bdy
  let [sorted_is, sorted_bins] = loop_res


-- sorted_vals = map(\i -> vs[i]) sorted_is
  val_idx <- newParam "val_idx" $ Prim int64
  sorted_vals_body <- runBodyBuilder . localScope (scopeOfLParams [val_idx]) $ do
    body <- letSubExp "body" $ BasicOp $ Index vs (fullSlice (Prim int64) [DimFix (Var (paramName val_idx))])     
    resultBodyM [body]
  let sorted_vals_lambda = Lambda [val_idx] sorted_vals_body [Prim int64]
  sorted_vals <- letExp "sorted_vals" $ Op $ Screma n' [sorted_is] $ ScremaForm [][] sorted_vals_lambda

  let trueSE  = Constant $ IntValue $ intValue Int8 (1 :: Integer)
  let falseSE = Constant $ IntValue $ intValue Int8 (0 :: Integer)

  -- final_flags = 
  --   map (\(bin, index) -> 
  --       if sorted_bins[index] == sorted_bins[index-1] 
  --       then 0 
  --       else 1
  --     ) sorted_bins (iota n')
  iota_n' <- letExp "iota_n'" $ BasicOp $ Iota n' zeroSubExp oneSubExp Int64
  bin <- newParam "bin" $ Prim int64
  index <- newParam "iot_n'" $ Prim $ int64
  mk_flag_body <- runBodyBuilder . localScope (scopeOfLParams [bin, index]) $ do
    
    idx_minus_one <- letSubExp "idx_minus_one" $ BasicOp $ BinOp (Sub Int64 OverflowUndef) (Var $ paramName index) oneSubExp
    prev_elem <- letExp "prev_elem" $ BasicOp $ Index vs (fullSlice (Prim int64) [DimFix idx_minus_one]) 
    
    let firstElem =
          eCmpOp
            (CmpEq $ IntType Int64)
            (eSubExp $ Var $ paramName index)
            (eSubExp zeroSubExp)

    let elemEq =
          eCmpOp
            (CmpEq $ IntType Int64)
            (eSubExp $ Var prev_elem)
            (eSubExp $ Var $ paramName bin)
    eBody
      [
        eIf
          firstElem
          (resultBodyM $ [trueSE])
          (eBody
            [
              eIf
                elemEq
                (resultBodyM $ [falseSE])
                (resultBodyM $ [trueSE])
            ])
      ]
  let mk_flag_lambda = Lambda [bin, index] mk_flag_body [Prim $ IntType Int8]
  final_flags <- letExp "final_flags" $ Op $ Screma n' [sorted_bins, iota_n'] $ ScremaForm [][] mk_flag_lambda


  -- fwd_scan = sgmScanExc op sorted_vals final_flags
  seg_scan_exc <- mkSegScanExc f nes n' sorted_vals final_flags
  fwd_scan <- letTupExp "fwd_scan" $ Op seg_scan_exc
  let [_, lis] = fwd_scan

  -- rev_vals = reverse sorted_vals
  rev_vals <- eReverse sorted_vals
  -- final_flags_rev = reverse final_flags
  final_flags_rev <- eReverse final_flags


  -- Need to fix flags after reversing
  -- rev_flags = map (\ind -> if ind == 0 then 1 else rev_final_flags[ind-1]) (iota n')
  i' <- newParam "i" $ Prim int64
  rev_flags_body <- runBodyBuilder . localScope (scopeOfLParams [i']) $ do
    idx_minus_one <- letSubExp "idx_minus_one" $ BasicOp $ BinOp (Sub Int64 OverflowUndef) (Var $ paramName i') (intConst Int64 1)
    prev_elem <- letSubExp "prev_elem" $ BasicOp $ Index final_flags_rev (fullSlice (Prim int64) [DimFix idx_minus_one]) 
    let firstElem =
          eCmpOp
            (CmpEq $ IntType Int64)
            (eSubExp $ Var $ paramName i')
            (eSubExp zeroSubExp)
    eBody
      [
        eIf
          firstElem
          (resultBodyM [Constant $ IntValue $ intValue Int8 (1 :: Integer)])
          (resultBodyM [prev_elem])
      ]
  let rev_flags_lambda = Lambda [i'] rev_flags_body [Prim int8]
  rev_flags <- letExp "rev_flags" $ Op $ Screma n' [iota_n'] $ ScremaForm [][] rev_flags_lambda


  -- rev_scan = sgmScanExc op rev_vals rev_flags
  rev_seg_scan_exc <- mkSegScanExc f nes n' rev_vals rev_flags
  rev_scan <- letTupExp "rev_scan" $ Op rev_seg_scan_exc
  let [_, ris] = rev_scan





  -- This part is just to let dev -s return something useful
  -- return the first w values in array ------- Change this vvv to the most recent expression
  last_sliced <- letExp "last_arr_sliced" $ BasicOp $ Index ris $ fullSlice (Prim bitType) [DimSlice zeroSubExp wsubexp (constant (1 :: Int64))]
  -- This gives zero atm, who cares it stays just because it will compile
  addStm $ Let pat aux $ BasicOp $ Index ris $ fullSlice (Prim bitType) [DimSlice zeroSubExp wsubexp (constant (1 :: Int64))]
  m
  -- Adjoint value is equal to sliced - allows me to sneakpeak at generated code
  insAdj orig_dst last_sliced
diffGeneralRBI _ _ _ _ _ = error $ "Pattern matching failed in diffGeneralRBI"

-- TODO
-- 1. Remove all unnecessary parameters and clean up code (better comments?)
-- 2. Support non identity lambdas for the histogram in vjpSOAC.
--     We need to unwrap it and then call the function it holds with is and vs to get the real values 
-- 3. Explain the pseudocode and the implemented code in the report
-- 4. Read through all aux functions and remove unneccessary parts
diffPlusRBI ::
  Pat ->
  StmAux () ->
  (SubExp, [VName], Lambda) ->
  (Shape, SubExp, VName, SubExp, Lambda) ->
  ADM () ->
  ADM ()
diffPlusRBI pat@(Pat [pe]) aux (n, arrs@([is, vs]), f) (w, rf, orig_dst, ne, add_lam) m = do


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
diffPlusRBI _ _ _ _ _ = error "Pattern matching failed in diffPlusRBI"
  
diffMulRBI ::
  Pat ->
  StmAux () ->
  (SubExp, [VName]) ->
  (Shape, SubExp, VName, SubExp, Lambda, BinOp) ->
  ADM () ->
  ADM ()
diffMulRBI (Pat [pe]) aux (n, [is, vs]) (w@(Shape [wsubexp]), rf, orig_dst, ne, mul_lam, mulOp) m = do

  let t = binOpType mulOp
  t_zero <- letSubExp "t_zero" $ zeroExp $ Prim t
  t_one <- letSubExp "t_one" $ oneExp $ Prim t
  
  let zeroVal = intValue Int64 (0 :: Integer)
  let zeroSubExp = Constant $ IntValue $ zeroVal
  let oneSubExp = Constant $ IntValue $ intValue Int64 (1 :: Integer)
  
  ------  FORWARD  ------

  -- Zero count map function
  -- map (\v_f -> if v_f==0 then 1 else 0)
  v_f <- newParam "v_f" $ Prim t
  zero_map_lam_bdy <- runBodyBuilder . localScope (scopeOfLParams [v_f]) $ do
    eBody
     [eIf
          (eCmpOp (CmpEq t) (eParam v_f) (toExp t_zero))
          ( eBody
              [ eSubExp oneSubExp ]
          )
          ( eBody
              [ eSubExp zeroSubExp ]
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
              [ toExp t_one ]
          )
          ( eBody
              [ eParam v_f2 ]
          )
     ]
  let nzp_map_lam = Lambda [v_f2] nzp_map_lam_bdy [Prim t]
  vs_nonzeros <- letExp "nonzero_values" $ Op $ Screma n [vs] (ScremaForm [] [] nzp_map_lam)
  

  zr_counts0 <- letExp "zr_cts" $ BasicOp $ Replicate (w) zeroSubExp
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
  let hist_zrn = HistOp w rf [zr_counts0] [zeroSubExp] lam_add_int64
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
          (toExp $ le64 zr_count .>. pe64 zeroSubExp)
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
            wsubexp 
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
          (eCmpOp (CmpEq $ IntType Int64) (eSubExp $ Var zr_cts) (eSubExp zeroSubExp) )
          ( eBody
            [ eBinOp mulOp (eBinOp (getBinOpDiv mulOp) (eSubExp $ Var nz_prd) (eParam v_b)) (eSubExp $ Var pr_bar)]
            
          )
          ( eBody
            [ eIf 
                ( eBinOp LogAnd
                    (eCmpOp (CmpEq t) (eParam v_b) (toExp t_zero))
                    (eCmpOp (CmpEq $ IntType Int64) (eSubExp $ Var zr_cts) (eSubExp oneSubExp) )
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
diffMulRBI _ _ _ _ _ = error "Pattern matching failed in diffMulRBI"

diffMinMaxRBI ::
  Pat ->
  StmAux () ->
  (SubExp, [VName]) ->
  (Shape, SubExp, VName, SubExp, BinOp) ->
  ADM () ->
  ADM ()
diffMinMaxRBI (Pat [pe]) aux (n, [is, vs]) (w@(Shape [wsubexp]), rf, orig_dst, ne, bop) m = do

  let t = binOpType bop
  
  let negOne = intConst Int64 (-1::Integer)

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

  -- where
  --   mkI64ArrType len = Array int64 (Shape [len]) NoUniqueness
diffMinMaxRBI _ _ _ _ _ = error "Pattern matching failed in diffMinMaxRBI"


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