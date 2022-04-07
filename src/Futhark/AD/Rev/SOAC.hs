{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeFamilies #-}

module Futhark.AD.Rev.SOAC (vjpSOAC) where

import Control.Monad
import Futhark.AD.Rev.Map
import Futhark.AD.Rev.Monad
import Futhark.AD.Rev.Reduce
import Futhark.AD.Rev.Scan
import Futhark.AD.Rev.Scatter
import Futhark.AD.Rev.RBI
import Futhark.Analysis.PrimExp.Convert
import Futhark.Builder
import Futhark.IR.SOACS
import Futhark.Tools
import Futhark.Util (chunks)

data BinOpType = Addition BinOp | Multiplication BinOp | MinMax BinOp


-- We split any multi-op scan or reduction into multiple operations so
-- we can detect special cases.  Post-AD, the result may be fused
-- again.
splitScanRed ::
  VjpOps ->
  ([a] -> ADM (ScremaForm SOACS), a -> [SubExp]) ->
  (Pat, StmAux (), [a], SubExp, [VName]) ->
  ADM () ->
  ADM ()
splitScanRed vjpops (opSOAC, opNeutral) (pat, aux, ops, w, as) m = do
  let ks = map (length . opNeutral) ops
      pat_per_op = map Pat $ chunks ks $ patElems pat
      as_per_op = chunks ks as
      onOps (op : ops') (op_pat : op_pats') (op_as : op_as') = do
        op_form <- opSOAC [op]
        vjpSOAC vjpops op_pat aux (Screma w op_as op_form) $
          onOps ops' op_pats' op_as'
      onOps _ _ _ = m
  onOps ops pat_per_op as_per_op

commonSOAC :: Pat -> StmAux () -> SOAC SOACS -> ADM () -> ADM [Adj]
commonSOAC pat aux soac m = do
  addStm $ Let pat aux $ Op soac
  m
  returnSweepCode $ mapM lookupAdj $ patNames pat

vjpSOAC :: VjpOps -> Pat -> StmAux () -> SOAC SOACS -> ADM () -> ADM ()
vjpSOAC ops pat aux soac@(Screma w as form) m
  | Just reds <- isReduceSOAC form,
    length reds > 1 =
    splitScanRed ops (reduceSOAC, redNeutral) (pat, aux, reds, w, as) m
  | Just [red] <- isReduceSOAC form,
    [x] <- patNames pat,
    [ne] <- redNeutral red,
    [a] <- as,
    Just [(op, _, _, _)] <- lamIsBinOp $ redLambda red,
    isMinMaxOp op =
    diffMinMaxReduce ops x aux w op ne a m
  | Just red <- singleReduce <$> isReduceSOAC form = do
    pat_adj <- mapM adjVal =<< commonSOAC pat aux soac m
    diffReduce ops pat_adj w as red
  where
    isMinMaxOp (SMin _) = True
    isMinMaxOp (UMin _) = True
    isMinMaxOp (FMin _) = True
    isMinMaxOp (SMax _) = True
    isMinMaxOp (UMax _) = True
    isMinMaxOp (FMax _) = True
    isMinMaxOp _ = False
vjpSOAC ops pat aux soac@(Screma w as form) m
  | Just scans <- isScanSOAC form,
    length scans > 1 =
    splitScanRed ops (scanSOAC, scanNeutral) (pat, aux, scans, w, as) m
  | Just red <- singleScan <$> isScanSOAC form = do
    void $ commonSOAC pat aux soac m
    diffScan ops (patNames pat) w as red
vjpSOAC ops pat aux soac@(Screma w as form) m
  | Just lam <- isMapSOAC form = do
    pat_adj <- commonSOAC pat aux soac m
    vjpMap ops pat_adj w lam as
vjpSOAC ops pat _aux (Screma w as form) m
  | Just (reds, map_lam) <-
      isRedomapSOAC form = do
    (mapstm, redstm) <-
      redomapToMapAndReduce pat (w, reds, map_lam, as)
    vjpStm ops mapstm $ vjpStm ops redstm m
vjpSOAC ops pat aux (Scatter w lam ass written_info) m =
  vjpScatter ops pat aux (w, lam, ass, written_info) m

vjpSOAC ops pat aux (Hist n arrs [hist_inner] f) m 
  | not $ isIdentityLambda f
    = do 
        identityLam <- mkIdentityLambda $ lambdaReturnType f        
        (arr_result, stms ) <- runBuilderT' . localScope (scopeOfLParams []) $ do
          letTupExp "unfolded_arrs" $ Op $ Screma n arrs (mapSOAC f)
        let map_stm = head $ stmsToList stms
        let newhist = Let pat aux $ Op $ Hist n arr_result [hist_inner] identityLam
        vjpStm ops map_stm $ vjpStm ops newhist m 

vjpSOAC _ pat aux (Hist n arrs [hist_add] f) m 
  | isIdentityLambda f,
    HistOp w rf [orig_dst] [ne] add_lam <- hist_add,
    Just (Addition _) <- isBinOpTypeLam add_lam 
    = 
      diffPlusRBI pat aux (n, arrs, f) (w, rf, orig_dst, ne, add_lam) m
vjpSOAC _ pat aux (Hist n arrs [hist_add] f) m 
  | isIdentityLambda f,
    HistOp w rf [orig_dst] [ne] mul_lam <- hist_add,
    Just (Multiplication bop) <- isBinOpTypeLam mul_lam 
    = 
      diffMulRBI pat aux (n, arrs) (w, rf, orig_dst, ne, mul_lam, bop) m
vjpSOAC _ pat aux (Hist n arrs [hist_add] f) m 
  | isIdentityLambda f,
    HistOp w rf [orig_dst] [ne] bop_lam <- hist_add,
    Just (MinMax bop) <- isBinOpTypeLam bop_lam 
    = 
      diffMinMaxRBI pat aux (n, arrs) (w, rf, orig_dst, ne, bop) m
vjpSOAC _ pat aux (Hist n arrs [inner_hist] f) m 
  | isIdentityLambda f,
    HistOp w _ [orig_dst] nes lam <- inner_hist
    = 
      diffGeneralRBI pat aux (n, arrs) (w, nes, orig_dst, lam) m
vjpSOAC _ _ _ soac _ =
  error $ "vjpSOAC unhandled:\n" ++ pretty soac
 

isBinOpTypeLam :: Lambda -> Maybe BinOpType
isBinOpTypeLam lam = isSpecOpLam isAddOp $ filterMapOp lam
  where
    isAddOp bop@(Add _ _) = Just $ Addition bop
    isAddOp bop@(FAdd _) = Just $ Addition bop
    isAddOp bop@(Mul _ _) = Just $ Multiplication bop
    isAddOp bop@(FMul _) = Just $ Multiplication bop
    isAddOp bop@(SMin _) = Just $ MinMax bop
    isAddOp bop@(UMin _) = Just $ MinMax bop
    isAddOp bop@(FMin _) = Just $ MinMax bop
    isAddOp bop@(SMax _) = Just $ MinMax bop
    isAddOp bop@(UMax _) = Just $ MinMax bop
    isAddOp bop@(FMax _) = Just $ MinMax bop
    isAddOp _ = Nothing
    filterMapOp (Lambda [pa1, pa2] lam_body _)
      | [r] <- bodyResult lam_body,
        [map_stm] <- stmsToList (bodyStms lam_body),
        (Let pat _ (Op scrm)) <- map_stm,
        (Pat [pe]) <- pat,
        (Screma _ [a1, a2] (ScremaForm [] [] map_lam)) <- scrm,
        (a1 == paramName pa1 && a2 == paramName pa2) || (a1 == paramName pa2 && a2 == paramName pa1),
        resSubExp r == Var (patElemName pe) =
        filterMapOp map_lam
    filterMapOp other_lam = other_lam

-- Pattern Matches special lambda cases:
--   plus, multiplication, min, max, which are all commutative.
-- Succeeds for (\ x y -> x binop y) or (\x y -> y binop x).
isSpecOpLam :: (BinOp -> Maybe BinOpType) -> Lambda -> Maybe BinOpType
isSpecOpLam isOp lam =
  isRedStm
    (map paramName $ lambdaParams lam)
    (bodyResult $ lambdaBody lam)
    (stmsToList $ bodyStms $ lambdaBody lam)
  where
    isRedStm [a, b] [r] [Let (Pat [pe]) _aux (BasicOp (BinOp op x y))] =
      if (resSubExp r == Var (patElemName pe)) && ((x == Var a && y == Var b) || (x == Var b && y == Var a))
        then isOp op
        else Nothing
    isRedStm _ _ _ = Nothing
