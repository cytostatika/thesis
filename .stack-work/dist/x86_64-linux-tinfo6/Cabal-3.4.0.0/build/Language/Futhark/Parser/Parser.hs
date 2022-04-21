{-# OPTIONS_GHC -w #-}
{-# OPTIONS -XMagicHash -XBangPatterns -XTypeSynonymInstances -XFlexibleInstances -cpp #-}
#if __GLASGOW_HASKELL__ >= 710
{-# OPTIONS_GHC -XPartialTypeSignatures #-}
#endif
{-# LANGUAGE TupleSections #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE Trustworthy #-}
-- | Futhark parser written with Happy.
module Language.Futhark.Parser.Parser
  ( prog
  , expression
  , modExpression
  , futharkType
  , anyValue
  , anyValues

  , ParserMonad
  , parse
  , ParseError(..)
  , parseDecOrExpIncrM
  )
  where

import Control.Monad
import Control.Monad.Trans
import Control.Monad.Except
import Control.Monad.Reader
import Control.Monad.Trans.State
import Data.Array
import qualified Data.ByteString as BS
import qualified Data.Text as T
import qualified Data.Text.Encoding as T
import Data.Char (ord)
import Data.Maybe (fromMaybe, fromJust)
import Data.List (genericLength)
import qualified Data.List.NonEmpty as NE
import qualified Data.Map.Strict as M
import Data.Monoid

import Language.Futhark.Syntax hiding (ID)
import Language.Futhark.Prop
import Language.Futhark.Pretty
import Language.Futhark.Parser.Lexer
import Futhark.Util.Pretty
import Futhark.Util.Loc hiding (L) -- Lexer has replacements.
import qualified Data.Array as Happy_Data_Array
import qualified Data.Bits as Bits
import qualified GHC.Exts as Happy_GHC_Exts
import Control.Applicative(Applicative(..))
import Control.Monad (ap)

-- parser produced by Happy Version 1.20.0

newtype HappyAbsSyn t115 t116 t117 t118 = HappyAbsSyn HappyAny
#if __GLASGOW_HASKELL__ >= 607
type HappyAny = Happy_GHC_Exts.Any
#else
type HappyAny = forall a . a
#endif
newtype HappyWrap10 = HappyWrap10 (DocComment)
happyIn10 :: (DocComment) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn10 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap10 x)
{-# INLINE happyIn10 #-}
happyOut10 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap10
happyOut10 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut10 #-}
newtype HappyWrap11 = HappyWrap11 (UncheckedProg)
happyIn11 :: (UncheckedProg) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn11 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap11 x)
{-# INLINE happyIn11 #-}
happyOut11 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap11
happyOut11 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut11 #-}
newtype HappyWrap12 = HappyWrap12 (UncheckedDec)
happyIn12 :: (UncheckedDec) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn12 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap12 x)
{-# INLINE happyIn12 #-}
happyOut12 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap12
happyOut12 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut12 #-}
newtype HappyWrap13 = HappyWrap13 ([UncheckedDec])
happyIn13 :: ([UncheckedDec]) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn13 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap13 x)
{-# INLINE happyIn13 #-}
happyOut13 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap13
happyOut13 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut13 #-}
newtype HappyWrap14 = HappyWrap14 (UncheckedDec)
happyIn14 :: (UncheckedDec) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn14 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap14 x)
{-# INLINE happyIn14 #-}
happyOut14 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap14
happyOut14 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut14 #-}
newtype HappyWrap15 = HappyWrap15 (UncheckedSigExp)
happyIn15 :: (UncheckedSigExp) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn15 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap15 x)
{-# INLINE happyIn15 #-}
happyOut15 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap15
happyOut15 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut15 #-}
newtype HappyWrap16 = HappyWrap16 (TypeRefBase NoInfo Name)
happyIn16 :: (TypeRefBase NoInfo Name) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn16 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap16 x)
{-# INLINE happyIn16 #-}
happyOut16 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap16
happyOut16 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut16 #-}
newtype HappyWrap17 = HappyWrap17 (SigBindBase NoInfo Name)
happyIn17 :: (SigBindBase NoInfo Name) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn17 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap17 x)
{-# INLINE happyIn17 #-}
happyOut17 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap17
happyOut17 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut17 #-}
newtype HappyWrap18 = HappyWrap18 (UncheckedModExp)
happyIn18 :: (UncheckedModExp) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn18 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap18 x)
{-# INLINE happyIn18 #-}
happyOut18 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap18
happyOut18 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut18 #-}
newtype HappyWrap19 = HappyWrap19 (UncheckedModExp)
happyIn19 :: (UncheckedModExp) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn19 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap19 x)
{-# INLINE happyIn19 #-}
happyOut19 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap19
happyOut19 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut19 #-}
newtype HappyWrap20 = HappyWrap20 (UncheckedModExp)
happyIn20 :: (UncheckedModExp) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn20 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap20 x)
{-# INLINE happyIn20 #-}
happyOut20 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap20
happyOut20 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut20 #-}
newtype HappyWrap21 = HappyWrap21 (UncheckedSigExp)
happyIn21 :: (UncheckedSigExp) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn21 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap21 x)
{-# INLINE happyIn21 #-}
happyOut21 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap21
happyOut21 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut21 #-}
newtype HappyWrap22 = HappyWrap22 (ModBindBase NoInfo Name)
happyIn22 :: (ModBindBase NoInfo Name) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn22 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap22 x)
{-# INLINE happyIn22 #-}
happyOut22 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap22
happyOut22 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut22 #-}
newtype HappyWrap23 = HappyWrap23 (ModParamBase NoInfo Name)
happyIn23 :: (ModParamBase NoInfo Name) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn23 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap23 x)
{-# INLINE happyIn23 #-}
happyOut23 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap23
happyOut23 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut23 #-}
newtype HappyWrap24 = HappyWrap24 ([ModParamBase NoInfo Name])
happyIn24 :: ([ModParamBase NoInfo Name]) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn24 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap24 x)
{-# INLINE happyIn24 #-}
happyOut24 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap24
happyOut24 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut24 #-}
newtype HappyWrap25 = HappyWrap25 (Liftedness)
happyIn25 :: (Liftedness) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn25 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap25 x)
{-# INLINE happyIn25 #-}
happyOut25 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap25
happyOut25 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut25 #-}
newtype HappyWrap26 = HappyWrap26 (SpecBase NoInfo Name)
happyIn26 :: (SpecBase NoInfo Name) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn26 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap26 x)
{-# INLINE happyIn26 #-}
happyOut26 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap26
happyOut26 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut26 #-}
newtype HappyWrap27 = HappyWrap27 ([SpecBase NoInfo Name])
happyIn27 :: ([SpecBase NoInfo Name]) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn27 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap27 x)
{-# INLINE happyIn27 #-}
happyOut27 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap27
happyOut27 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut27 #-}
newtype HappyWrap28 = HappyWrap28 (SizeBinder Name)
happyIn28 :: (SizeBinder Name) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn28 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap28 x)
{-# INLINE happyIn28 #-}
happyOut28 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap28
happyOut28 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut28 #-}
newtype HappyWrap29 = HappyWrap29 ([SizeBinder Name])
happyIn29 :: ([SizeBinder Name]) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn29 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap29 x)
{-# INLINE happyIn29 #-}
happyOut29 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap29
happyOut29 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut29 #-}
newtype HappyWrap30 = HappyWrap30 (TypeParamBase Name)
happyIn30 :: (TypeParamBase Name) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn30 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap30 x)
{-# INLINE happyIn30 #-}
happyOut30 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap30
happyOut30 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut30 #-}
newtype HappyWrap31 = HappyWrap31 ([TypeParamBase Name])
happyIn31 :: ([TypeParamBase Name]) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn31 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap31 x)
{-# INLINE happyIn31 #-}
happyOut31 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap31
happyOut31 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut31 #-}
newtype HappyWrap32 = HappyWrap32 ((QualName Name, SrcLoc))
happyIn32 :: ((QualName Name, SrcLoc)) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn32 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap32 x)
{-# INLINE happyIn32 #-}
happyOut32 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap32
happyOut32 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut32 #-}
newtype HappyWrap33 = HappyWrap33 (Name)
happyIn33 :: (Name) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn33 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap33 x)
{-# INLINE happyIn33 #-}
happyOut33 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap33
happyOut33 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut33 #-}
newtype HappyWrap34 = HappyWrap34 ((Name, SrcLoc))
happyIn34 :: ((Name, SrcLoc)) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn34 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap34 x)
{-# INLINE happyIn34 #-}
happyOut34 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap34
happyOut34 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut34 #-}
newtype HappyWrap35 = HappyWrap35 (ValBindBase NoInfo Name)
happyIn35 :: (ValBindBase NoInfo Name) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn35 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap35 x)
{-# INLINE happyIn35 #-}
happyOut35 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap35
happyOut35 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut35 #-}
newtype HappyWrap36 = HappyWrap36 (TypeDeclBase NoInfo Name)
happyIn36 :: (TypeDeclBase NoInfo Name) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn36 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap36 x)
{-# INLINE happyIn36 #-}
happyOut36 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap36
happyOut36 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut36 #-}
newtype HappyWrap37 = HappyWrap37 (TypeBindBase NoInfo Name)
happyIn37 :: (TypeBindBase NoInfo Name) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn37 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap37 x)
{-# INLINE happyIn37 #-}
happyOut37 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap37
happyOut37 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut37 #-}
newtype HappyWrap38 = HappyWrap38 (UncheckedTypeExp)
happyIn38 :: (UncheckedTypeExp) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn38 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap38 x)
{-# INLINE happyIn38 #-}
happyOut38 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap38
happyOut38 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut38 #-}
newtype HappyWrap39 = HappyWrap39 ([Name])
happyIn39 :: ([Name]) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn39 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap39 x)
{-# INLINE happyIn39 #-}
happyOut39 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap39
happyOut39 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut39 #-}
newtype HappyWrap40 = HappyWrap40 (UncheckedTypeExp)
happyIn40 :: (UncheckedTypeExp) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn40 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap40 x)
{-# INLINE happyIn40 #-}
happyOut40 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap40
happyOut40 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut40 #-}
newtype HappyWrap41 = HappyWrap41 (UncheckedTypeExp)
happyIn41 :: (UncheckedTypeExp) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn41 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap41 x)
{-# INLINE happyIn41 #-}
happyOut41 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap41
happyOut41 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut41 #-}
newtype HappyWrap42 = HappyWrap42 (([(Name, [UncheckedTypeExp])], SrcLoc))
happyIn42 :: (([(Name, [UncheckedTypeExp])], SrcLoc)) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn42 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap42 x)
{-# INLINE happyIn42 #-}
happyOut42 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap42
happyOut42 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut42 #-}
newtype HappyWrap43 = HappyWrap43 ((Name, [UncheckedTypeExp], SrcLoc))
happyIn43 :: ((Name, [UncheckedTypeExp], SrcLoc)) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn43 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap43 x)
{-# INLINE happyIn43 #-}
happyOut43 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap43
happyOut43 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut43 #-}
newtype HappyWrap44 = HappyWrap44 (UncheckedTypeExp)
happyIn44 :: (UncheckedTypeExp) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn44 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap44 x)
{-# INLINE happyIn44 #-}
happyOut44 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap44
happyOut44 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut44 #-}
newtype HappyWrap45 = HappyWrap45 (UncheckedTypeExp)
happyIn45 :: (UncheckedTypeExp) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn45 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap45 x)
{-# INLINE happyIn45 #-}
happyOut45 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap45
happyOut45 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut45 #-}
newtype HappyWrap46 = HappyWrap46 ((Name, SrcLoc))
happyIn46 :: ((Name, SrcLoc)) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn46 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap46 x)
{-# INLINE happyIn46 #-}
happyOut46 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap46
happyOut46 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut46 #-}
newtype HappyWrap47 = HappyWrap47 (TypeArgExp Name)
happyIn47 :: (TypeArgExp Name) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn47 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap47 x)
{-# INLINE happyIn47 #-}
happyOut47 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap47
happyOut47 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut47 #-}
newtype HappyWrap48 = HappyWrap48 ((Name, UncheckedTypeExp))
happyIn48 :: ((Name, UncheckedTypeExp)) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn48 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap48 x)
{-# INLINE happyIn48 #-}
happyOut48 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap48
happyOut48 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut48 #-}
newtype HappyWrap49 = HappyWrap49 ([(Name, UncheckedTypeExp)])
happyIn49 :: ([(Name, UncheckedTypeExp)]) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn49 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap49 x)
{-# INLINE happyIn49 #-}
happyOut49 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap49
happyOut49 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut49 #-}
newtype HappyWrap50 = HappyWrap50 ([UncheckedTypeExp])
happyIn50 :: ([UncheckedTypeExp]) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn50 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap50 x)
{-# INLINE happyIn50 #-}
happyOut50 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap50
happyOut50 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut50 #-}
newtype HappyWrap51 = HappyWrap51 (DimExp Name)
happyIn51 :: (DimExp Name) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn51 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap51 x)
{-# INLINE happyIn51 #-}
happyOut51 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap51
happyOut51 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut51 #-}
newtype HappyWrap52 = HappyWrap52 (PatBase NoInfo Name)
happyIn52 :: (PatBase NoInfo Name) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn52 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap52 x)
{-# INLINE happyIn52 #-}
happyOut52 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap52
happyOut52 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut52 #-}
newtype HappyWrap53 = HappyWrap53 ((PatBase NoInfo Name, [PatBase NoInfo Name]))
happyIn53 :: ((PatBase NoInfo Name, [PatBase NoInfo Name])) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn53 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap53 x)
{-# INLINE happyIn53 #-}
happyOut53 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap53
happyOut53 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut53 #-}
newtype HappyWrap54 = HappyWrap54 ([PatBase NoInfo Name])
happyIn54 :: ([PatBase NoInfo Name]) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn54 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap54 x)
{-# INLINE happyIn54 #-}
happyOut54 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap54
happyOut54 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut54 #-}
newtype HappyWrap55 = HappyWrap55 ((QualName Name, SrcLoc))
happyIn55 :: ((QualName Name, SrcLoc)) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn55 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap55 x)
{-# INLINE happyIn55 #-}
happyOut55 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap55
happyOut55 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut55 #-}
newtype HappyWrap56 = HappyWrap56 (UncheckedExp)
happyIn56 :: (UncheckedExp) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn56 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap56 x)
{-# INLINE happyIn56 #-}
happyOut56 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap56
happyOut56 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut56 #-}
newtype HappyWrap57 = HappyWrap57 (UncheckedExp)
happyIn57 :: (UncheckedExp) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn57 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap57 x)
{-# INLINE happyIn57 #-}
happyOut57 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap57
happyOut57 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut57 #-}
newtype HappyWrap58 = HappyWrap58 (UncheckedExp)
happyIn58 :: (UncheckedExp) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn58 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap58 x)
{-# INLINE happyIn58 #-}
happyOut58 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap58
happyOut58 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut58 #-}
newtype HappyWrap59 = HappyWrap59 ([UncheckedExp])
happyIn59 :: ([UncheckedExp]) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn59 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap59 x)
{-# INLINE happyIn59 #-}
happyOut59 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap59
happyOut59 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut59 #-}
newtype HappyWrap60 = HappyWrap60 (UncheckedExp)
happyIn60 :: (UncheckedExp) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn60 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap60 x)
{-# INLINE happyIn60 #-}
happyOut60 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap60
happyOut60 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut60 #-}
newtype HappyWrap61 = HappyWrap61 ((PrimValue, SrcLoc))
happyIn61 :: ((PrimValue, SrcLoc)) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn61 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap61 x)
{-# INLINE happyIn61 #-}
happyOut61 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap61
happyOut61 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut61 #-}
newtype HappyWrap62 = HappyWrap62 ((PrimValue, SrcLoc))
happyIn62 :: ((PrimValue, SrcLoc)) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn62 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap62 x)
{-# INLINE happyIn62 #-}
happyOut62 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap62
happyOut62 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut62 #-}
newtype HappyWrap63 = HappyWrap63 ((UncheckedExp, [UncheckedExp]))
happyIn63 :: ((UncheckedExp, [UncheckedExp])) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn63 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap63 x)
{-# INLINE happyIn63 #-}
happyOut63 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap63
happyOut63 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut63 #-}
newtype HappyWrap64 = HappyWrap64 (([UncheckedExp], UncheckedExp))
happyIn64 :: (([UncheckedExp], UncheckedExp)) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn64 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap64 x)
{-# INLINE happyIn64 #-}
happyOut64 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap64
happyOut64 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut64 #-}
newtype HappyWrap65 = HappyWrap65 ((Name, SrcLoc))
happyIn65 :: ((Name, SrcLoc)) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn65 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap65 x)
{-# INLINE happyIn65 #-}
happyOut65 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap65
happyOut65 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut65 #-}
newtype HappyWrap66 = HappyWrap66 ([(Name, SrcLoc)])
happyIn66 :: ([(Name, SrcLoc)]) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn66 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap66 x)
{-# INLINE happyIn66 #-}
happyOut66 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap66
happyOut66 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut66 #-}
newtype HappyWrap67 = HappyWrap67 ([(Name, SrcLoc)])
happyIn67 :: ([(Name, SrcLoc)]) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn67 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap67 x)
{-# INLINE happyIn67 #-}
happyOut67 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap67
happyOut67 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut67 #-}
newtype HappyWrap68 = HappyWrap68 (FieldBase NoInfo Name)
happyIn68 :: (FieldBase NoInfo Name) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn68 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap68 x)
{-# INLINE happyIn68 #-}
happyOut68 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap68
happyOut68 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut68 #-}
newtype HappyWrap69 = HappyWrap69 ([FieldBase NoInfo Name])
happyIn69 :: ([FieldBase NoInfo Name]) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn69 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap69 x)
{-# INLINE happyIn69 #-}
happyOut69 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap69
happyOut69 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut69 #-}
newtype HappyWrap70 = HappyWrap70 ([FieldBase NoInfo Name])
happyIn70 :: ([FieldBase NoInfo Name]) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn70 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap70 x)
{-# INLINE happyIn70 #-}
happyOut70 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap70
happyOut70 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut70 #-}
newtype HappyWrap71 = HappyWrap71 (UncheckedExp)
happyIn71 :: (UncheckedExp) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn71 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap71 x)
{-# INLINE happyIn71 #-}
happyOut71 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap71
happyOut71 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut71 #-}
newtype HappyWrap72 = HappyWrap72 (UncheckedExp)
happyIn72 :: (UncheckedExp) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn72 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap72 x)
{-# INLINE happyIn72 #-}
happyOut72 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap72
happyOut72 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut72 #-}
newtype HappyWrap73 = HappyWrap73 (UncheckedExp)
happyIn73 :: (UncheckedExp) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn73 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap73 x)
{-# INLINE happyIn73 #-}
happyOut73 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap73
happyOut73 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut73 #-}
newtype HappyWrap74 = HappyWrap74 (NE.NonEmpty (CaseBase NoInfo Name))
happyIn74 :: (NE.NonEmpty (CaseBase NoInfo Name)) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn74 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap74 x)
{-# INLINE happyIn74 #-}
happyOut74 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap74
happyOut74 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut74 #-}
newtype HappyWrap75 = HappyWrap75 (CaseBase NoInfo Name)
happyIn75 :: (CaseBase NoInfo Name) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn75 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap75 x)
{-# INLINE happyIn75 #-}
happyOut75 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap75
happyOut75 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut75 #-}
newtype HappyWrap76 = HappyWrap76 (PatBase NoInfo Name)
happyIn76 :: (PatBase NoInfo Name) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn76 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap76 x)
{-# INLINE happyIn76 #-}
happyOut76 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap76
happyOut76 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut76 #-}
newtype HappyWrap77 = HappyWrap77 ([PatBase NoInfo Name])
happyIn77 :: ([PatBase NoInfo Name]) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn77 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap77 x)
{-# INLINE happyIn77 #-}
happyOut77 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap77
happyOut77 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut77 #-}
newtype HappyWrap78 = HappyWrap78 (PatBase NoInfo Name)
happyIn78 :: (PatBase NoInfo Name) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn78 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap78 x)
{-# INLINE happyIn78 #-}
happyOut78 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap78
happyOut78 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut78 #-}
newtype HappyWrap79 = HappyWrap79 ([PatBase NoInfo Name])
happyIn79 :: ([PatBase NoInfo Name]) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn79 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap79 x)
{-# INLINE happyIn79 #-}
happyOut79 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap79
happyOut79 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut79 #-}
newtype HappyWrap80 = HappyWrap80 ((Name, PatBase NoInfo Name))
happyIn80 :: ((Name, PatBase NoInfo Name)) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn80 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap80 x)
{-# INLINE happyIn80 #-}
happyOut80 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap80
happyOut80 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut80 #-}
newtype HappyWrap81 = HappyWrap81 ([(Name, PatBase NoInfo Name)])
happyIn81 :: ([(Name, PatBase NoInfo Name)]) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn81 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap81 x)
{-# INLINE happyIn81 #-}
happyOut81 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap81
happyOut81 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut81 #-}
newtype HappyWrap82 = HappyWrap82 ([(Name, PatBase NoInfo Name)])
happyIn82 :: ([(Name, PatBase NoInfo Name)]) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn82 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap82 x)
{-# INLINE happyIn82 #-}
happyOut82 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap82
happyOut82 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut82 #-}
newtype HappyWrap83 = HappyWrap83 ((PatLit, SrcLoc))
happyIn83 :: ((PatLit, SrcLoc)) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn83 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap83 x)
{-# INLINE happyIn83 #-}
happyOut83 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap83
happyOut83 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut83 #-}
newtype HappyWrap84 = HappyWrap84 (LoopFormBase NoInfo Name)
happyIn84 :: (LoopFormBase NoInfo Name) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn84 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap84 x)
{-# INLINE happyIn84 #-}
happyOut84 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap84
happyOut84 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut84 #-}
newtype HappyWrap85 = HappyWrap85 (((Name, SrcLoc), UncheckedSlice, SrcLoc))
happyIn85 :: (((Name, SrcLoc), UncheckedSlice, SrcLoc)) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn85 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap85 x)
{-# INLINE happyIn85 #-}
happyOut85 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap85
happyOut85 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut85 #-}
newtype HappyWrap86 = HappyWrap86 (((QualName Name, SrcLoc), UncheckedSlice, SrcLoc))
happyIn86 :: (((QualName Name, SrcLoc), UncheckedSlice, SrcLoc)) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn86 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap86 x)
{-# INLINE happyIn86 #-}
happyOut86 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap86
happyOut86 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut86 #-}
newtype HappyWrap87 = HappyWrap87 (UncheckedDimIndex)
happyIn87 :: (UncheckedDimIndex) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn87 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap87 x)
{-# INLINE happyIn87 #-}
happyOut87 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap87
happyOut87 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut87 #-}
newtype HappyWrap88 = HappyWrap88 ([UncheckedDimIndex])
happyIn88 :: ([UncheckedDimIndex]) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn88 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap88 x)
{-# INLINE happyIn88 #-}
happyOut88 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap88
happyOut88 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut88 #-}
newtype HappyWrap89 = HappyWrap89 ((UncheckedDimIndex, [UncheckedDimIndex]))
happyIn89 :: ((UncheckedDimIndex, [UncheckedDimIndex])) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn89 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap89 x)
{-# INLINE happyIn89 #-}
happyOut89 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap89
happyOut89 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut89 #-}
newtype HappyWrap90 = HappyWrap90 (IdentBase NoInfo Name)
happyIn90 :: (IdentBase NoInfo Name) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn90 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap90 x)
{-# INLINE happyIn90 #-}
happyOut90 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap90
happyOut90 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut90 #-}
newtype HappyWrap91 = HappyWrap91 ((Name, SrcLoc))
happyIn91 :: ((Name, SrcLoc)) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn91 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap91 x)
{-# INLINE happyIn91 #-}
happyOut91 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap91
happyOut91 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut91 #-}
newtype HappyWrap92 = HappyWrap92 (PatBase NoInfo Name)
happyIn92 :: (PatBase NoInfo Name) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn92 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap92 x)
{-# INLINE happyIn92 #-}
happyOut92 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap92
happyOut92 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut92 #-}
newtype HappyWrap93 = HappyWrap93 ([PatBase NoInfo Name])
happyIn93 :: ([PatBase NoInfo Name]) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn93 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap93 x)
{-# INLINE happyIn93 #-}
happyOut93 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap93
happyOut93 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut93 #-}
newtype HappyWrap94 = HappyWrap94 (PatBase NoInfo Name)
happyIn94 :: (PatBase NoInfo Name) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn94 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap94 x)
{-# INLINE happyIn94 #-}
happyOut94 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap94
happyOut94 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut94 #-}
newtype HappyWrap95 = HappyWrap95 ((Name, PatBase NoInfo Name))
happyIn95 :: ((Name, PatBase NoInfo Name)) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn95 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap95 x)
{-# INLINE happyIn95 #-}
happyOut95 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap95
happyOut95 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut95 #-}
newtype HappyWrap96 = HappyWrap96 ([(Name, PatBase NoInfo Name)])
happyIn96 :: ([(Name, PatBase NoInfo Name)]) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn96 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap96 x)
{-# INLINE happyIn96 #-}
happyOut96 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap96
happyOut96 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut96 #-}
newtype HappyWrap97 = HappyWrap97 ([(Name, PatBase NoInfo Name)])
happyIn97 :: ([(Name, PatBase NoInfo Name)]) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn97 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap97 x)
{-# INLINE happyIn97 #-}
happyOut97 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap97
happyOut97 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut97 #-}
newtype HappyWrap98 = HappyWrap98 ((AttrAtom Name, SrcLoc))
happyIn98 :: ((AttrAtom Name, SrcLoc)) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn98 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap98 x)
{-# INLINE happyIn98 #-}
happyOut98 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap98
happyOut98 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut98 #-}
newtype HappyWrap99 = HappyWrap99 (AttrInfo Name)
happyIn99 :: (AttrInfo Name) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn99 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap99 x)
{-# INLINE happyIn99 #-}
happyOut99 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap99
happyOut99 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut99 #-}
newtype HappyWrap100 = HappyWrap100 ([AttrInfo Name])
happyIn100 :: ([AttrInfo Name]) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn100 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap100 x)
{-# INLINE happyIn100 #-}
happyOut100 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap100
happyOut100 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut100 #-}
newtype HappyWrap101 = HappyWrap101 (Value)
happyIn101 :: (Value) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn101 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap101 x)
{-# INLINE happyIn101 #-}
happyOut101 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap101
happyOut101 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut101 #-}
newtype HappyWrap102 = HappyWrap102 ([Value])
happyIn102 :: ([Value]) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn102 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap102 x)
{-# INLINE happyIn102 #-}
happyOut102 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap102
happyOut102 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut102 #-}
newtype HappyWrap103 = HappyWrap103 (PrimType)
happyIn103 :: (PrimType) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn103 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap103 x)
{-# INLINE happyIn103 #-}
happyOut103 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap103
happyOut103 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut103 #-}
newtype HappyWrap104 = HappyWrap104 (Value)
happyIn104 :: (Value) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn104 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap104 x)
{-# INLINE happyIn104 #-}
happyOut104 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap104
happyOut104 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut104 #-}
newtype HappyWrap105 = HappyWrap105 (Value)
happyIn105 :: (Value) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn105 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap105 x)
{-# INLINE happyIn105 #-}
happyOut105 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap105
happyOut105 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut105 #-}
newtype HappyWrap106 = HappyWrap106 (Value)
happyIn106 :: (Value) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn106 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap106 x)
{-# INLINE happyIn106 #-}
happyOut106 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap106
happyOut106 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut106 #-}
newtype HappyWrap107 = HappyWrap107 (Value)
happyIn107 :: (Value) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn107 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap107 x)
{-# INLINE happyIn107 #-}
happyOut107 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap107
happyOut107 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut107 #-}
newtype HappyWrap108 = HappyWrap108 ((IntValue, SrcLoc))
happyIn108 :: ((IntValue, SrcLoc)) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn108 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap108 x)
{-# INLINE happyIn108 #-}
happyOut108 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap108
happyOut108 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut108 #-}
newtype HappyWrap109 = HappyWrap109 ((IntValue, SrcLoc))
happyIn109 :: ((IntValue, SrcLoc)) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn109 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap109 x)
{-# INLINE happyIn109 #-}
happyOut109 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap109
happyOut109 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut109 #-}
newtype HappyWrap110 = HappyWrap110 ((FloatValue, SrcLoc))
happyIn110 :: ((FloatValue, SrcLoc)) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn110 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap110 x)
{-# INLINE happyIn110 #-}
happyOut110 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap110
happyOut110 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut110 #-}
newtype HappyWrap111 = HappyWrap111 (Value)
happyIn111 :: (Value) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn111 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap111 x)
{-# INLINE happyIn111 #-}
happyOut111 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap111
happyOut111 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut111 #-}
newtype HappyWrap112 = HappyWrap112 (Int64)
happyIn112 :: (Int64) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn112 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap112 x)
{-# INLINE happyIn112 #-}
happyOut112 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap112
happyOut112 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut112 #-}
newtype HappyWrap113 = HappyWrap113 (ValueType)
happyIn113 :: (ValueType) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn113 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap113 x)
{-# INLINE happyIn113 #-}
happyOut113 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap113
happyOut113 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut113 #-}
newtype HappyWrap114 = HappyWrap114 ([Value])
happyIn114 :: ([Value]) -> (HappyAbsSyn t115 t116 t117 t118)
happyIn114 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap114 x)
{-# INLINE happyIn114 #-}
happyOut114 :: (HappyAbsSyn t115 t116 t117 t118) -> HappyWrap114
happyOut114 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut114 #-}
happyIn115 :: t115 -> (HappyAbsSyn t115 t116 t117 t118)
happyIn115 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn115 #-}
happyOut115 :: (HappyAbsSyn t115 t116 t117 t118) -> t115
happyOut115 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut115 #-}
happyIn116 :: t116 -> (HappyAbsSyn t115 t116 t117 t118)
happyIn116 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn116 #-}
happyOut116 :: (HappyAbsSyn t115 t116 t117 t118) -> t116
happyOut116 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut116 #-}
happyIn117 :: t117 -> (HappyAbsSyn t115 t116 t117 t118)
happyIn117 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn117 #-}
happyOut117 :: (HappyAbsSyn t115 t116 t117 t118) -> t117
happyOut117 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut117 #-}
happyIn118 :: t118 -> (HappyAbsSyn t115 t116 t117 t118)
happyIn118 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn118 #-}
happyOut118 :: (HappyAbsSyn t115 t116 t117 t118) -> t118
happyOut118 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut118 #-}
happyInTok :: (L Token) -> (HappyAbsSyn t115 t116 t117 t118)
happyInTok x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyInTok #-}
happyOutTok :: (HappyAbsSyn t115 t116 t117 t118) -> (L Token)
happyOutTok x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOutTok #-}


happyExpList :: HappyAddr
happyExpList = HappyA# "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x06\x00\x00\x00\x00\x00\x00\x00\x80\x80\x00\x70\x07\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xb8\x00\x00\x40\x00\x00\x00\x90\x02\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x90\x40\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x06\x00\x00\x00\x00\x00\x00\x00\x80\x80\x00\x70\x07\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\xfe\xff\x80\x00\x00\x00\x00\x02\x00\x30\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\xe0\xff\x0f\x08\x00\x00\x00\x20\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\xe0\xff\x0f\x08\x00\x00\x00\x20\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x10\x00\x10\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\xe0\xc3\x0b\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\xfe\xff\x80\x00\x00\x00\x00\x06\x00\x30\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x60\x00\x00\x00\x00\x00\x00\x00\x00\x08\x08\x00\x37\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x09\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x90\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x10\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x0c\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x90\x40\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x06\x00\x00\x00\x00\x00\x00\x00\x80\x80\x00\x70\x07\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x09\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x90\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x09\x04\x00\x10\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x60\x00\x00\x00\x00\x00\x00\x00\x00\x08\x08\x00\x77\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x06\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xde\xf6\xff\xff\x0f\x00\x04\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xf8\xfe\xff\x00\x00\x00\x00\x90\x02\x00\x30\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x10\x00\x10\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa4\xfa\xfe\xff\x80\x01\x00\x00\x90\x4a\x00\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x01\x00\x00\x00\x00\x00\x00\xa9\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x90\x28\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa4\xfa\xfe\xff\x80\x01\x00\x00\x90\x4a\x20\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x82\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa4\xfa\xfe\xff\x80\x01\x00\x00\x90\x4a\x00\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa4\xfa\xfe\xff\x80\x01\x00\x00\x90\x4a\x00\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xff\xff\x1f\x7c\xff\xff\xff\xab\x44\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xe9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x09\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xf8\xfe\xff\x00\x00\x00\x00\x90\x02\x00\x30\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x10\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x10\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x08\x00\x00\x00\x00\x00\x00\x09\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x88\x00\x00\x00\x00\x00\x00\x90\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xb8\x00\x00\x40\x00\x00\x00\x90\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x0b\x00\x00\x04\x00\x00\x00\x2b\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x02\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x20\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x06\x00\x00\x00\x00\x00\x00\x00\x80\x80\x00\x70\x07\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x06\x00\x00\x00\x00\x00\x00\x00\x80\x80\x00\x70\x07\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x60\x00\x00\x00\x00\x00\x00\x00\x00\x08\x08\x00\x77\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x60\x00\x00\x00\x00\x00\x00\x00\x00\x08\x08\x00\x37\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x06\x00\x00\x00\x00\x00\x00\x00\x80\x80\x00\x70\x07\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x0b\x00\x00\x04\x00\x00\x00\x29\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x10\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x10\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x10\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x10\x00\x10\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xb8\x00\x00\x40\x00\x00\x00\xb0\x02\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x20\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xb8\x00\x00\x40\x00\x00\x00\x90\x02\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\xef\xff\x0f\x00\x00\x00\x00\x29\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x90\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\xc0\xf6\xff\xff\xbf\x28\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x06\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa4\xfa\xfe\xff\x80\x01\x00\x00\xb0\x4a\x00\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x06\x01\x06\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xde\xf6\xff\xff\x0f\x00\x04\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x10\x00\x10\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xab\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x60\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xe0\x6d\xff\xff\xff\x00\x40\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x10\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x82\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x06\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x41\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x90\x28\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x06\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa4\xfa\xfe\xff\x80\x01\x00\x00\x90\x4a\x00\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa4\xfa\xfe\xff\x80\x01\x00\x00\x90\x4a\x00\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa4\xfa\xfe\xff\x80\x01\x00\x00\x90\x4a\x00\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa4\xfa\xfe\xff\x80\x01\x00\x00\x90\x4a\x00\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa4\xfa\xfe\xff\x80\x01\x00\x00\x90\x4a\x00\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa4\xfa\xfe\xff\x80\x01\x00\x00\x90\x4a\x00\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa4\xfa\xfe\xff\x80\x01\x00\x00\x90\x4a\x00\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa4\xfa\xfe\xff\x80\x01\x00\x00\x90\x4a\x00\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa4\xfa\xfe\xff\x80\x01\x00\x00\x90\x4a\x00\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa4\xfa\xfe\xff\x80\x01\x00\x00\x90\x4a\x00\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa4\xfa\xfe\xff\x80\x01\x00\x00\x90\x4a\x00\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa4\xfa\xfe\xff\x80\x01\x00\x00\x90\x4a\x00\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa4\xfa\xfe\xff\x80\x01\x00\x00\x90\x4a\x00\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa4\xfa\xfe\xff\x80\x01\x00\x00\x90\x4a\x00\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa4\xfa\xfe\xff\x80\x01\x00\x00\x90\x4a\x00\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa4\xfa\xfe\xff\x80\x01\x00\x00\x90\x4a\x00\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x02\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x0b\x00\x00\x04\x00\x00\x00\x29\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xb8\x00\x00\x40\x00\x00\x00\x90\x02\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x09\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x10\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x18\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x82\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xc0\xf6\xff\xff\x0f\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x82\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x6c\xff\xff\xff\x00\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x6c\xff\xff\xff\x8b\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x82\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x6c\xff\xff\xff\x00\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\xfe\xff\x80\x00\x00\x00\x00\x02\x00\x30\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x90\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x82\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x09\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x09\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x90\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x06\x00\x00\x00\x00\x00\x00\x00\x80\x80\x00\x70\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x09\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x82\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x41\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x09\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x80\x4e\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x10\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x82\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x6c\xff\xff\x39\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xc0\xf6\xff\x9f\x0b\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x0c\xfe\xc0\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xc0\xe0\x0f\x1c\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x0c\xfe\xc0\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xc0\xf6\xff\xdf\x0f\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x6c\xff\xff\xfd\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xc0\xe0\x0f\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x0c\xfe\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4c\xff\xc0\x39\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xc0\xf4\x0f\x9c\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4c\xff\xc0\x39\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xc0\xf4\x0f\x9c\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4c\xff\xc0\x39\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xc0\xf4\x0f\x9c\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x80\x0f\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\xf8\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xc0\xe0\x0f\x1c\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x0c\xfe\xc0\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xc0\xf4\x0f\x9c\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\xf8\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xe0\x6d\xff\xff\xff\x00\x40\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xde\xf6\xff\xff\x0f\x00\x04\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xe0\x6d\xff\xff\xff\x00\x40\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xde\xf6\xff\xff\x0f\x00\x04\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xde\xf6\xff\xff\x0f\x00\x04\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x09\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa4\xfa\xfe\xff\x80\x01\x00\x00\x90\x4a\x00\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x0b\x00\x00\x04\x00\x00\x00\x29\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x90\x28\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x88\xfe\xbf\x80\x00\x00\x00\x90\x28\x00\x30\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xde\xf6\xff\xff\x0f\x00\x24\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x82\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa4\xfa\xfe\xff\x80\x01\x00\x00\x90\x4a\x20\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa4\xfa\xfe\xff\x80\x01\x00\x00\x90\x4a\x20\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa4\xfa\xfe\xff\x80\x01\x00\x00\xb0\x4a\x00\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa4\xfa\xfe\xff\x80\x01\x00\x00\x90\x4a\x00\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa4\xfa\xfe\xff\x80\x01\x00\x00\x90\x4a\x00\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa4\xfa\xfe\xff\x80\x01\x00\x00\x90\x4a\x00\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa4\xfa\xfe\xff\x80\x01\x00\x00\x90\x4a\x00\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa4\xfa\xfe\xff\x80\x01\x00\x00\x90\x4a\x00\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa4\xfa\xfe\xff\x80\x01\x00\x00\x90\x4a\x00\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa4\xfa\xfe\xff\x80\x01\x00\x00\x90\x4a\x00\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa4\xfa\xfe\xff\x80\x01\x00\x00\x90\x4a\x00\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa4\xfa\xfe\xff\x80\x01\x00\x00\x90\x4a\x00\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa4\xfa\xfe\xff\x80\x01\x00\x00\x90\x4a\x00\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa4\xfa\xfe\xff\x80\x01\x00\x00\x90\x4a\x00\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa4\xfa\xfe\xff\x80\x01\x00\x00\x90\x4a\x00\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa4\xfa\xfe\xff\x80\x01\x00\x00\x90\x4a\x00\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x82\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa4\xfa\xfe\xff\x80\x01\x00\x00\x90\x4a\x00\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xe0\x6d\xff\xff\xff\x02\x40\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa4\xfa\xfe\xff\x80\x01\x00\x00\x90\x4a\x00\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x02\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xb8\x00\x00\x40\x00\x00\x00\x90\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x88\x00\x00\x00\x00\x00\x00\x90\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x0b\x00\x00\x04\x00\x00\x00\x29\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x0b\x00\x00\x04\x00\x00\x00\x29\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xb8\x00\x00\x40\x00\x00\x00\x90\x02\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xb8\x00\x00\x40\x00\x00\x00\x90\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xb8\x00\x00\x40\x00\x00\x00\x90\x02\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x60\x00\x00\x00\x00\x00\x00\x00\x00\x08\x08\x00\x77\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x10\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x89\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xb8\x00\x00\x40\x00\x00\x00\x90\x02\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x06\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x10\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x06\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x06\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xde\xf6\xff\xff\x0f\x00\x24\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xe0\x6d\xff\xff\xff\x00\x40\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa4\xfa\xfe\xff\x80\x01\x00\x00\x90\x4a\x00\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\xe8\xff\x0b\x08\x00\x00\x00\x09\x02\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xfe\x3f\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\xe8\xff\x0b\x6c\xff\xff\xff\x8b\x42\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x60\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x60\x41\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x89\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa4\xfa\xfe\xff\x80\x01\x00\x00\x90\x4a\x00\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x16\x00\x00\x00\x00\x00\x00\x00\x00\x00\x06\x60\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x60\x01\x00\x00\x00\x00\x00\x00\x00\x00\x60\x00\x06\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x06\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa4\xfa\xfe\xff\x80\x01\x00\x00\x90\x4a\x00\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa4\xfa\xfe\xff\x80\x01\x00\x00\x90\x4a\x00\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa4\xfa\xfe\xff\x80\x01\x00\x00\x90\x4a\x00\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x09\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x90\x40\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x09\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x80\x4e\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\xe8\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x09\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x0c\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\xc0\xf6\xff\xff\x0f\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x41\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x01\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x09\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x90\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x90\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x09\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x90\x28\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\xfe\xff\x80\x00\x00\x00\x00\x02\x00\x30\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xb8\x00\x00\x40\x00\x00\x00\x90\x02\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x0b\x00\x00\x04\x00\x00\x00\x29\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x82\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x41\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x10\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x09\x04\x00\x10\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x10\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x09\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x82\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x18\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x41\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x10\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x10\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x6c\xff\xff\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x6c\xff\xff\xff\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xde\xf6\xff\xff\x0f\x00\x04\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xe0\x6d\xff\xff\xff\x00\x40\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xde\xf6\xff\xff\x0f\x00\x04\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa4\xfa\xfe\xff\x80\x01\x00\x00\x90\x4a\x00\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x60\x01\x00\x00\x00\x00\x00\x00\x00\x00\x60\x00\x06\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x60\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa4\xfa\xfe\xff\x80\x01\x00\x00\x90\x4a\x00\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x10\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xe0\xff\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xb8\x00\x00\x40\x00\x00\x00\x90\x02\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x88\xfe\xbf\x80\x00\x00\x00\x90\x20\x00\x30\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xe0\x6d\xff\xff\xff\x00\x40\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xde\xf6\xff\xff\x0f\x00\x04\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x06\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x10\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xb8\x00\x00\x40\x00\x00\x00\x90\x02\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x0b\x00\x00\x04\x00\x00\x00\x29\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xde\xf6\xff\xff\x0f\x00\x04\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\xe8\xff\x0b\x08\x00\x00\x00\x89\x02\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\xe8\xff\x0b\x08\x00\x00\x00\x89\x02\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xb8\x00\x00\x40\x00\x00\x00\x90\x02\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\xe8\xff\x0b\x08\x00\x00\x00\x89\x02\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x60\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x06\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa4\xfa\xfe\xff\x80\x01\x00\x00\x90\x4a\x00\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x60\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x60\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x80\x4e\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x09\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x10\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa4\xfa\xfe\xff\x80\x01\x00\x00\x90\x4a\x00\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\xaa\xef\xff\x0f\x18\x00\x00\x00\xa9\x04\x80\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x89\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa4\xfa\xfe\xff\x80\x01\x00\x00\x90\x4a\x00\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa4\xfa\xfe\xff\x80\x01\x00\x00\x90\x4a\x00\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x06\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x60\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x60\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x06\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x60\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x0b\x00\x00\x04\x00\x00\x00\x29\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xb8\x00\x00\x40\x00\x00\x00\x90\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xb8\x00\x00\x40\x00\x00\x00\x90\x02\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x0b\x00\x00\x04\x00\x00\x00\x29\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x10\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xc0\xf6\xff\xff\x0f\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x16\x00\x00\x00\x00\x00\x00\x00\x00\x00\x06\x60\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x60\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\xe8\xff\x0b\x08\x00\x00\x00\x89\x02\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x38\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x90\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x41\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"#

{-# NOINLINE happyExpListPerState #-}
happyExpListPerState st =
    token_strs_expected
  where token_strs = ["error","%dummy","%start_prog","%start_futharkType","%start_expression","%start_modExpression","%start_declaration","%start_anyValue","%start_anyValues","Doc","Prog","Dec","Decs","Dec_","SigExp","TypeRef","SigBind","ModExp","ModExpApply","ModExpAtom","SimpleSigExp","ModBind","ModParam","ModParams","Liftedness","Spec","Specs","SizeBinder","SizeBinders1","TypeParam","TypeParams","BinOp","BindingBinOp","BindingId","Val","TypeExpDecl","TypeAbbr","TypeExp","TypeExpDims","TypeExpTerm","SumType","SumClauses","SumClause","TypeExpApply","TypeExpAtom","Constr","TypeArg","FieldType","FieldTypes1","TupleTypes","DimExp","FunParam","FunParams1","FunParams","QualName","Exp","Exp2","Apply_","ApplyList","Atom","NumLit","PrimLit","Exps1","Exps1_","FieldAccess","FieldAccesses","FieldAccesses_","Field","Fields","Fields1","LetExp","LetBody","MatchExp","Cases","Case","CPat","CPats1","CInnerPat","ConstrFields","CFieldPat","CFieldPats","CFieldPats1","CaseLiteral","LoopForm","VarSlice","QualVarSlice","DimIndex","DimIndices","DimIndices1","VarId","FieldId","Pat","Pats1","InnerPat","FieldPat","FieldPats","FieldPats1","AttrAtom","AttrInfo","Attrs","Value","CatValues","PrimType","IntValue","FloatValue","StringValue","BoolValue","SignedLit","UnsignedLit","FloatLit","ArrayValue","Dim","ValueType","Values","maybeAscription__SigExp__","maybeAscription__SimpleSigExp__","maybeAscription__TypeExpDecl__","maybeAscription__TypeExpTerm__","if","then","else","let","def","loop","in","match","case","id","'id['","'qid['","'qid.('","constructor","'.int'","intlit","i8lit","i16lit","i32lit","i64lit","u8lit","u16lit","u32lit","u64lit","floatlit","f16lit","f32lit","f64lit","stringlit","charlit","'.'","'..'","'...'","'..<'","'..>'","'='","'*'","'-'","'!'","'<'","'^'","'~'","'|'","'+...'","'-...'","'*...'","'/...'","'%...'","'//...'","'%%...'","'==...'","'!=...'","'<...'","'>...'","'<=...'","'>=...'","'**...'","'<<...'","'>>...'","'|>...'","'<|...'","'|...'","'&...'","'^...'","'||...'","'&&...'","'('","')'","')['","'{'","'}'","'['","']'","'#['","','","'_'","'\\\\'","'\\''","'\\'^'","'\\'~'","'`'","entry","'->'","':'","':>'","'?'","for","do","with","assert","true","false","while","include","import","type","module","val","open","local","doc","%eof"]
        bit_start = st Prelude.* 220
        bit_end = (st Prelude.+ 1) Prelude.* 220
        read_bit = readArrayBit happyExpList
        bits = Prelude.map read_bit [bit_start..bit_end Prelude.- 1]
        bits_indexed = Prelude.zip bits [0..219]
        token_strs_expected = Prelude.concatMap f bits_indexed
        f (Prelude.False, _) = []
        f (Prelude.True, nr) = [token_strs Prelude.!! nr]

happyActOffsets :: HappyAddr
happyActOffsets = HappyA# "\xfd\xff\x29\x02\x67\x04\xfb\xff\xfd\xff\x17\x00\x17\x00\xb8\xff\x00\x00\x00\x00\x17\x00\xd4\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xff\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xf4\x04\xda\x05\x00\x00\x00\x00\xd4\xff\x04\x00\xd4\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x51\x00\x51\x00\xc6\x01\x2e\x00\xa4\x00\xfc\xff\xf9\xff\xfb\xff\xfd\xff\x8a\x00\x13\x01\x13\x01\x00\x00\x44\x01\xfb\xff\xfd\xff\xaf\x00\xe4\x00\x00\x00\x00\x00\x6e\x00\x45\x07\x00\x00\x5d\x05\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x44\x01\x67\x04\xb4\x00\xbc\x00\x67\x04\xcf\x00\xcf\x00\x67\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x67\x04\x67\x04\x73\x00\xf8\x01\x2b\x01\x22\x02\x09\x01\x5d\x05\x00\x00\x00\x00\xa6\x00\xcb\x00\x00\x00\x35\x01\x11\x01\xea\x00\x00\x00\x00\x00\x00\x00\x38\x02\x38\x02\xf5\x03\x71\x01\x35\x00\x02\x00\x27\x01\xfd\xff\x7a\x01\xfd\xff\xfd\xff\x00\x00\x04\x00\xfd\xff\x9b\x01\x6c\x01\x7f\x01\x00\x00\x00\x00\xf5\x03\x8a\x01\xa3\x01\xaf\x01\x00\x00\x00\x00\x00\x00\x65\x01\xf5\xff\x00\x00\x00\x00\xcd\x01\xdc\x01\xed\x01\x00\x00\x00\x00\x07\x00\x00\x00\x08\x02\x29\x02\x5d\x05\x09\x01\xf2\x01\x00\x00\x00\x00\x12\x06\x7a\x02\x00\x00\x00\x00\x2b\x02\xfe\x01\x00\x00\x3d\x02\x34\x02\x15\x02\x00\x00\x52\x02\x5b\x02\x00\x00\x86\x02\x24\x00\x87\x01\x25\x01\x77\x07\x44\x01\x00\x00\x09\x00\x00\x00\xe3\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xc6\x02\x00\x00\x00\x00\xe4\x01\x74\x06\xa7\x02\x96\x02\x00\x00\x3f\x02\xa2\x02\xfe\xff\xe9\xff\xa8\x02\x94\x02\xbe\x02\xbc\x00\x17\x03\x1a\x03\x40\x02\x21\x03\x19\x00\x44\x01\x00\x00\x39\x03\x67\x04\x00\x00\x67\x04\x67\x04\x67\x04\x67\x04\x67\x04\x67\x04\x67\x04\x67\x04\x67\x04\x67\x04\x67\x04\x67\x04\x67\x04\x67\x04\x67\x04\x67\x04\x67\x04\x67\x04\x67\x04\x67\x04\x67\x04\x67\x04\x67\x04\x67\x04\x67\x04\x67\x04\x67\x04\x67\x04\x67\x04\x67\x04\x67\x04\x67\x04\x3e\x03\x05\x00\x29\x02\x29\x02\x00\x00\x01\x03\x58\x03\x31\x03\x6f\x01\x00\x00\x00\x00\x00\x00\x17\x01\x00\x00\x27\x03\x46\x03\x9c\x03\x24\x02\x00\x00\x00\x00\x00\x00\x0e\x04\x00\x00\x6b\x08\x68\x03\x0e\x04\x6b\x08\x92\x08\x12\x06\x0e\x04\xb9\x08\x00\x00\x2f\x00\x00\x00\x00\x00\x00\x00\x6e\x03\x00\x00\x74\x03\xae\x03\x00\x00\x17\x00\x00\x00\x09\x01\x00\x00\x0e\x04\x09\x01\xca\x03\xcd\x03\xd1\x03\xe5\x03\xad\x03\x88\x01\x00\x00\x09\x01\x09\x01\x04\x00\xb0\x03\x09\x01\x0e\x04\xf8\x03\xee\x03\xea\x03\xbc\x03\x67\x02\x00\x00\x18\x01\x7b\x02\x00\x00\x00\x00\xc0\x03\xe7\x03\x89\x00\x00\x00\x00\x00\x00\x00\x18\x04\x4d\x01\x9b\x02\xf0\x03\x11\x11\xf3\x10\xa3\x11\xa3\x11\xa3\x11\xd5\x10\xd5\x10\x3b\x06\x3b\x06\x00\x00\x2d\x11\x2d\x11\x2d\x11\x2d\x11\x2d\x11\x2d\x11\x0a\x04\x0a\x04\x0a\x04\x0a\x04\x0a\x04\x73\x03\x73\x03\xa3\x11\xa3\x11\x2d\x11\x73\x03\x0a\x04\xa9\x07\xa9\x07\xa9\x07\xdb\x07\xba\x04\x0d\x08\x00\x00\x00\x00\x67\x04\x01\x04\x09\x01\x67\x04\x67\x04\x33\x04\x00\x00\x23\x04\x29\x02\x16\x04\x67\x04\xc1\x00\x67\x04\x00\x00\x6d\x04\x74\x05\x00\x00\xa9\x06\x67\x04\x00\x00\x9b\x02\xf7\x02\x00\x00\x1f\x04\x00\x00\x53\x03\x4b\x04\x56\x04\x67\x04\xaf\x03\x67\x04\x67\x04\x67\x04\x67\x04\x67\x04\x67\x04\x67\x04\x67\x04\x67\x04\x67\x04\x67\x04\x67\x04\x67\x04\x67\x04\x67\x04\x67\x04\x67\x04\x67\x04\x67\x04\x67\x04\x67\x04\x67\x04\x67\x04\x67\x04\x67\x04\x67\x04\xa2\x04\x4d\x01\x0b\x04\x67\x04\xde\x06\x00\x00\x67\x04\x00\x00\xdd\x02\x67\x04\x00\x00\x2c\x00\x67\x04\x42\x00\x63\x04\x69\x04\x00\x00\x7a\x04\x76\x04\xf5\x03\x00\x00\x00\x00\x00\x00\x11\x01\x98\x04\x00\x00\x00\x00\x00\x00\x29\x02\x00\x00\x29\x02\x29\x02\x00\x00\xe0\x02\x00\x00\xf5\x03\x9b\x04\x29\x02\x00\x00\xfd\xff\x00\x00\x00\x00\x00\x00\x91\x04\x00\x00\x00\x00\x00\x00\x93\x04\xbb\x04\xbd\x04\x00\x00\x00\x00\x67\x04\x00\x00\x00\x00\xe0\x02\xce\x00\x29\x02\xc2\x02\xb8\x04\xc8\x04\x00\x00\xc2\x02\x00\x00\xc2\x02\x00\x00\xcd\x04\xce\x04\x00\x00\xd6\x04\x00\x00\x00\x00\x00\x00\xd0\x04\x00\x00\x10\x07\x67\x04\x00\x00\x0d\x08\x67\x04\xc3\x05\x00\x00\xde\x04\xe0\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa3\x12\x0a\x05\xe0\x02\xea\x02\x00\x00\x00\x00\xc2\x02\x2b\x05\x48\x05\x2d\x05\x20\x03\x67\x04\x00\x00\xce\x00\x67\x04\x15\x00\x15\x00\x08\x05\x00\x00\x03\x00\x67\x04\x67\x04\x67\x04\x67\x04\x1b\x05\x00\x00\x67\x04\x00\x00\x00\x00\x1c\x01\xfb\xff\x1c\x01\x7b\x02\x7b\x02\x3a\x05\x00\x00\xea\x02\x1c\x01\x69\x03\x79\x05\x4d\x06\xa0\x02\x01\x00\x1c\x01\x87\x05\x72\x05\x1c\x01\x00\x00\x1c\x01\x59\x05\x7b\x05\x09\x01\x5b\x05\x00\x00\x00\x00\x5b\x05\x5b\x05\x00\x00\xce\x00\xe0\x08\x00\x00\x00\x00\x00\x00\x6a\x05\x61\x05\x00\x00\x61\x05\x76\x05\x85\x05\x89\x05\x00\x00\x00\x00\x0c\x00\x00\x00\x17\x00\x99\x05\x29\x02\xbc\x05\x00\x00\xbf\x05\xc9\x05\xe3\x05\xea\x05\xec\x05\x00\x00\x29\x02\x0e\x04\xd9\x02\xd9\x02\xfb\xff\x00\x00\x0e\x04\xd9\x02\x1c\x01\x00\x00\x0e\x04\x0e\x04\x6b\x05\x94\x03\xd9\x02\xd4\x05\x00\x00\x00\x00\x00\x00\xd7\x02\x00\x00\xe9\x02\xb7\x10\xfc\x05\x3c\x08\x0d\x08\x0d\x08\x0d\x08\x67\x04\xfd\x05\x00\x00\x00\x00\x00\x00\x67\x04\x00\x00\x00\x00\x00\x00\x15\x00\x00\x00\x56\x03\xcd\x05\x67\x04\x67\x04\xde\x05\xdd\x05\xe2\x05\x00\x00\x71\x00\xe8\x05\xc7\x01\xa3\x12\x00\x00\x00\x00\x00\x00\x00\x00\x29\x02\x67\x04\x00\x00\x00\x00\xc3\x05\x0d\x08\x0d\x08\x67\x04\xe9\x05\x67\x04\x00\x00\x00\x00\x00\x00\x24\x03\x00\x00\x00\x00\x00\x00\x56\x03\xdc\x05\x00\x00\x29\x02\x00\x00\x00\x00\x29\x02\x00\x00\x00\x00\x0d\x08\x00\x00\x00\x00\x00\x00\x00\x00\x74\x05\x00\x00\x74\x05\x29\x02\x00\x00\x25\x03\x74\x05\x56\x03\x56\x03\x67\x04\x00\x00\x56\x03\x67\x04\x56\x03\x67\x04\x00\x00\x00\x00\x7b\x02\x0e\x04\x24\x06\x1c\x01\xe0\x05\xe5\x05\xed\x02\x0c\x06\x05\x06\x0d\x06\x00\x00\x67\x04\x67\x04\x67\x04\x00\x00\xce\x00\x67\x04\x00\x00\x67\x04\x00\x00\x00\x00\x00\x00\x00\x00\x56\x03\x56\x03\x00\x00\x56\x03\x56\x03\x56\x03\x29\x02\xf5\x03\x07\x06\x29\x02\x29\x02\xfd\x02\xf3\x05\x37\x06\x00\x00\xb7\x10\x15\x00\x56\x03\x00\x00\x00\x00\x00\x00\x00\x00\x14\x06\x19\x06\x00\x00\x00\x00\x74\x05\x00\x00\x0e\x04\x00\x00\x00\x00\x1c\x01\x00\x00\x00\x00\xfd\x02\x3e\x06\x00\x00\x00\x00"#

happyGotoOffsets :: HappyAddr
happyGotoOffsets = HappyA# "\x90\x11\x05\x12\xe7\x05\x04\x02\x99\x11\x73\x02\x17\x02\x00\x00\x00\x00\x00\x00\x68\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x97\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x8d\x00\xc1\x02\x00\x00\x00\x00\x00\x00\xe5\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xf6\x00\x10\x01\x79\x03\x4c\x06\x00\x00\x56\x06\x00\x00\x32\x02\xaa\x11\x00\x00\x0e\x00\xcc\x00\x00\x00\xc3\x03\x59\x02\x7c\x03\x59\x06\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x74\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xc6\x03\x55\x09\xf8\xff\xd0\x01\x68\x09\xb9\x03\x15\x04\x7b\x09\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x41\x0b\x52\x0b\x5d\x03\xe8\xff\x2f\x09\xb5\x03\x9f\x00\xdf\x05\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x2c\x04\x35\x07\x00\x00\x00\x00\x00\x00\x8f\x00\x3e\x02\x68\x04\x15\x12\xe3\x00\xb9\x02\x51\x06\xb3\x11\x00\x00\x95\x05\x6e\x11\x00\x00\xcc\x03\x74\x11\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x3f\x05\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xfc\x03\x00\x00\x00\x00\x15\x12\x00\x00\x00\x00\x00\x00\x00\x00\x49\x03\x00\x00\xc4\x01\x25\x12\x6f\x10\xa7\x00\x03\x06\x00\x00\x00\x00\xb1\x00\x89\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x63\x0b\x00\x00\x5a\x06\xff\x03\x00\x00\x00\x00\x00\x00\x74\x0b\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x44\x06\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x85\x0b\x00\x00\x1a\x04\x2d\x06\x00\x00\x11\x04\x7f\x04\x08\x03\x00\x00\x00\x00\x82\x04\x00\x00\x00\x00\x5c\x04\x00\x00\x00\x00\x96\x0b\x00\x00\xa7\x0b\xb8\x0b\xc9\x0b\xda\x0b\xeb\x0b\xfc\x0b\x0d\x0c\x1e\x0c\x2f\x0c\x40\x0c\x51\x0c\x62\x0c\x73\x0c\x84\x0c\x95\x0c\xa6\x0c\xb7\x0c\xc8\x0c\xd9\x0c\xea\x0c\xfb\x0c\x0c\x0d\x1d\x0d\x2e\x0d\x3f\x0d\x50\x0d\x61\x0d\x72\x0d\x83\x0d\x94\x0d\xa5\x0d\xb6\x0d\x63\x06\xe6\xff\x07\x07\x6e\x07\x00\x00\x27\x06\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x3f\x00\x00\x00\x00\x00\x95\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x90\x04\x00\x00\x9c\x04\x00\x00\xa1\x04\xa6\x04\x00\x00\xf9\x00\xf5\x04\x13\x05\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x2b\x06\x00\x00\x00\x00\x32\x06\x00\x00\x5d\x01\x00\x00\xd3\x00\x00\x00\x17\x05\x54\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x01\x57\x01\xd5\x03\x00\x00\x58\x01\x19\x05\x00\x00\x00\x00\x44\x05\x2a\x06\x00\x00\x00\x00\xe9\x00\x0f\x02\x00\x00\x00\x00\x00\x00\x00\x00\x9c\x01\x00\x00\x00\x00\x00\x00\x00\x00\x20\x05\x6c\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x8e\x09\x00\x00\xfa\x00\xa1\x09\xb4\x09\x00\x00\x00\x00\x00\x00\xa0\x07\x00\x00\xc7\x09\x32\x03\xda\x09\x00\x00\x3c\x05\x83\x10\x00\x00\x00\x00\xc7\x0d\x00\x00\x0b\x09\xd8\x0d\x00\x00\x00\x00\x00\x00\x77\x05\x00\x00\x00\x00\xe9\x0d\xfa\x0d\x0b\x0e\x1c\x0e\x2d\x0e\x3e\x0e\x4f\x0e\x60\x0e\x71\x0e\x82\x0e\x93\x0e\xa4\x0e\xb5\x0e\xc6\x0e\xd7\x0e\xe8\x0e\xf9\x0e\x0a\x0f\x1b\x0f\x2c\x0f\x3d\x0f\x4e\x0f\x5f\x0f\x70\x0f\x81\x0f\x92\x0f\xa3\x0f\xb4\x0f\x6e\x06\x22\x05\x03\x09\x42\x09\x00\x00\x00\x00\xed\x09\x00\x00\x75\x01\x00\x0a\x00\x00\x64\x02\x13\x0a\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xdb\x05\x00\x00\x00\x00\x00\x00\x2c\x04\x00\x00\x00\x00\x00\x00\x00\x00\x35\x12\x00\x00\xe5\x11\x45\x12\x00\x00\x3f\x01\x00\x00\x99\x06\x00\x00\x55\x12\x00\x00\x7f\x11\x00\x00\x00\x00\x00\x00\xa1\x06\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x26\x0a\x00\x00\x00\x00\x16\x01\x33\x03\xd2\x07\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xc5\x0f\x00\x00\x00\x00\xd6\x0f\x05\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x8c\x06\x03\x03\xe4\x03\x27\x05\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x76\x06\x39\x0a\x00\x00\x60\x03\x4c\x0a\x56\x05\x60\x05\x57\x06\x00\x00\x00\x00\xe7\x0f\xf8\x0f\x09\x10\x1a\x10\x00\x00\x00\x00\x2b\x10\x00\x00\x00\x00\x5c\x01\x60\x02\xa1\x01\xbf\x02\x70\x02\x00\x00\x00\x00\x54\x05\xa5\x01\xb2\x06\x00\x00\x9b\x05\x00\x00\x84\x05\xad\x01\x4a\x01\x00\x00\xbf\x01\x00\x00\xd7\x01\x00\x00\x00\x00\x62\x01\x58\x06\x00\x00\x00\x00\x5c\x06\x65\x06\x00\x00\x90\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x68\x06\x00\x00\x88\x06\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x0b\x01\x00\x00\xb9\x01\x00\x00\x04\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x65\x12\xb3\x05\x00\x00\x00\x00\x8e\x02\x00\x00\xb5\x05\x00\x00\xd8\x01\x00\x00\xb7\x05\xce\x05\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x5f\x0a\x00\x00\x00\x00\x00\x00\x00\x00\x72\x0a\x00\x00\x00\x00\x00\x00\xa8\x05\x00\x00\x00\x00\x00\x00\x85\x0a\x98\x0a\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x91\x06\x00\x00\x00\x00\x00\x00\x00\x00\x36\x08\xab\x0a\x00\x00\x00\x00\x3a\x02\x00\x00\x00\x00\x3c\x10\x00\x00\x4d\x10\x00\x00\x00\x00\x00\x00\xd6\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xf5\x11\x00\x00\x00\x00\x75\x12\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x62\x10\x00\x00\x8c\x10\x65\x08\x00\x00\x07\x03\x95\x10\x00\x00\x00\x00\xbe\x0a\x00\x00\x00\x00\xd1\x0a\x00\x00\x5e\x10\x00\x00\x00\x00\x18\x03\xd3\x05\x00\x00\xd9\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xe4\x0a\xf7\x0a\x0a\x0b\x00\x00\xec\x03\x1d\x0b\x00\x00\x30\x0b\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x85\x12\xce\x06\x00\x00\xc5\x11\xd5\x11\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xc4\x05\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x7a\x10\x00\x00\xf0\x05\x00\x00\x00\x00\xda\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"#

happyAdjustOffset :: Happy_GHC_Exts.Int# -> Happy_GHC_Exts.Int#
happyAdjustOffset off = off

happyDefActions :: HappyAddr
happyDefActions = HappyA# "\xf4\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x97\xfe\x00\x00\xf8\xff\x80\xfe\x97\xfe\x00\x00\x9d\xfe\x9c\xfe\x9b\xfe\x9a\xfe\x95\xfe\x93\xfe\x92\xfe\x99\xfe\x01\xff\x89\xfe\x8d\xfe\x8c\xfe\x8b\xfe\x8a\xfe\x87\xfe\x86\xfe\x85\xfe\x84\xfe\x7f\xfe\x83\xfe\x82\xfe\x81\xfe\x90\xfe\x88\xfe\x00\x00\x00\x00\x8f\xfe\x8e\xfe\x00\x00\x00\x00\x00\x00\xf3\xff\xed\xff\xec\xff\xef\xff\xee\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xcf\xff\x00\x00\x00\x00\x00\x00\x00\x00\xdc\xff\xdb\xff\xd7\xff\x01\xff\x00\x00\xf1\xff\x00\x00\x00\x00\x2b\xff\x1f\xff\x00\x00\x62\xff\x30\xff\x2f\xff\x2d\xff\x08\xff\x2c\xff\x5e\xff\x5d\xff\xc9\xfe\x01\xff\x00\x00\x00\x00\x00\x00\x00\x00\xbe\xfe\xbe\xfe\x00\x00\x75\xff\x29\xff\x15\xff\x14\xff\x13\xff\x12\xff\x11\xff\x10\xff\x0f\xff\x0e\xff\x28\xff\x0d\xff\x0c\xff\x0b\xff\x27\xff\x2a\xff\x00\x00\x00\x00\x00\x00\xfc\xfe\x00\x00\x00\x00\x00\x00\x00\x00\x0a\xff\x09\xff\x00\x00\x8d\xff\x76\xff\x85\xff\x83\xff\x87\xff\x7d\xff\x81\xff\x77\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xf1\xff\xf1\xff\xf5\xff\x00\x00\xf1\xff\x00\x00\x00\x00\x00\x00\x6c\xff\x6b\xff\x00\x00\x70\xff\x00\x00\x00\x00\xb9\xfe\xb8\xfe\x79\xff\x00\x00\x01\xff\x7b\xff\x8a\xff\x00\x00\x00\x00\x00\x00\x72\xff\x80\xff\x00\x00\x82\xff\x00\x00\x00\x00\x00\x00\x69\xff\x6d\xfe\x6a\xff\xb2\xfe\x00\x00\xa7\xfe\xb0\xfe\xa2\xfe\x00\x00\xa4\xfe\xa3\xfe\x05\xff\x00\x00\x07\xff\x21\xff\xfa\xfe\x00\x00\xfd\xfe\x00\x00\xb9\xfe\x00\x00\x00\x00\x62\xff\x01\xff\x03\xff\x00\x00\xb5\xff\x00\x00\x9e\xff\xa6\xff\xa3\xff\xb8\xff\xb7\xff\xb6\xff\xb4\xff\xb3\xff\xb2\xff\xb1\xff\xb0\xff\xaf\xff\xae\xff\xac\xff\xad\xff\xab\xff\xa8\xff\xa1\xff\xa2\xff\x9f\xff\xa0\xff\xa4\xff\xa5\xff\xa7\xff\xa9\xff\xaa\xff\x23\xff\x00\x00\x34\xff\x35\xff\x00\x00\xc7\xfe\xbc\xfe\x00\x00\xbd\xfe\xc3\xfe\x00\x00\x00\x00\x00\x00\xb5\xfe\x00\x00\xbf\xff\x00\x00\x00\x00\x00\x00\xb9\xff\x00\x00\x00\x00\x01\xff\x20\xff\x00\x00\x00\x00\x2e\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xdd\xff\x71\xfe\x00\x00\x00\x00\x00\x00\x65\xff\xda\xff\xd9\xff\x00\x00\xe9\xff\xeb\xff\xd0\xff\x00\x00\x00\x00\xcd\xff\xce\xff\xea\xff\xb9\xff\x9a\xff\x00\x00\x00\x00\xb9\xff\x00\x00\x9a\xff\x00\x00\xb9\xff\x00\x00\xf2\xff\x00\x00\x7b\xfe\x94\xfe\x91\xfe\x00\x00\x98\xfe\x00\x00\x00\x00\x7e\xfe\x75\xfe\x9c\xff\x00\x00\x9b\xff\xb9\xff\x67\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xaf\xfe\x00\x00\x67\xff\x00\x00\x00\x00\x67\xff\xb9\xff\x00\x00\x00\x00\xd0\xff\x73\xfe\xdf\xff\xe7\xff\x00\x00\xc2\xff\xd8\xff\xd6\xff\x00\x00\x00\x00\x00\x00\x63\xff\x93\xff\x64\xff\x00\x00\x01\xff\xbe\xfe\x00\x00\x4b\xff\x4a\xff\x49\xff\x4e\xff\x4d\xff\x40\xff\x41\xff\x50\xff\x4f\xff\x51\xff\x42\xff\x44\xff\x43\xff\x45\xff\x46\xff\x47\xff\x52\xff\x53\xff\x54\xff\x55\xff\x57\xff\x59\xff\x5a\xff\x4c\xff\x48\xff\x3f\xff\x58\xff\x56\xff\x3b\xff\x3c\xff\x3d\xff\x00\x00\x37\xff\x36\xff\x04\xff\x02\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xc0\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xf0\xfe\xef\xfe\x00\x00\xca\xfe\xc4\xfe\x00\x00\xc8\xfe\x00\x00\xc5\xfe\x1d\xff\x00\x00\x1c\xff\xbe\xfe\x00\x00\x00\x00\xb5\xff\x00\x00\x9e\xff\xa6\xff\xa3\xff\xb8\xff\xb7\xff\xb6\xff\xb4\xff\xb3\xff\xb2\xff\xb1\xff\xb0\xff\xaf\xff\xae\xff\xac\xff\xad\xff\xab\xff\xa8\xff\xa1\xff\xa2\xff\x9f\xff\xa0\xff\xa4\xff\xa5\xff\xa7\xff\xa9\xff\xaa\xff\x00\x00\x01\xff\xbe\xfe\x00\x00\x00\x00\x18\xff\x00\x00\x1e\xff\x00\x00\x00\x00\x22\xff\x00\x00\x00\x00\xa9\xfe\xa5\xfe\x00\x00\xa8\xfe\x00\x00\x00\x00\x00\x00\x68\xff\x5c\xff\x8f\xff\x84\xff\x00\x00\x73\xff\x7f\xff\x7e\xff\x00\x00\x7c\xff\x00\x00\x00\x00\x78\xff\x00\x00\x88\xff\x86\xff\x00\x00\x00\x00\xf6\xff\xf1\xff\xf0\xff\xf7\xff\x8e\xff\x8c\xff\x89\xff\x6f\xff\x71\xff\x6e\xff\x00\x00\x00\x00\x74\xff\x6e\xfe\x00\x00\xb1\xfe\xac\xfe\x00\x00\x00\x00\x00\x00\x5b\xff\x9f\xfe\x00\x00\xa1\xfe\x06\xff\xfb\xfe\xff\xfe\x1a\xff\x00\x00\x00\x00\x26\xff\x00\x00\x1b\xff\x19\xff\x17\xff\x00\x00\x9d\xff\xc6\xfe\x00\x00\xbb\xfe\xbf\xfe\x00\x00\xde\xfe\xd3\xfe\x00\x00\xea\xfe\xdf\xfe\xe6\xfe\xd2\xfe\xd1\xfe\xd4\xfe\x00\x00\x00\x00\xd7\xfe\x00\x00\xe4\xfe\xee\xfe\xcb\xfe\x00\x00\x00\x00\xb2\xfe\x00\x00\x00\x00\xb6\xfe\x00\x00\x00\x00\x00\x00\x00\x00\x6f\xfe\xc1\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xff\x00\x00\x72\xfe\xd5\xff\x00\x00\x00\x00\x00\x00\x00\x00\xc2\xff\x00\x00\xca\xff\x00\x00\x00\x00\xcf\xff\x00\x00\x00\x00\x00\x00\x01\xff\x00\x00\x00\x00\x00\x00\x00\x00\xd1\xff\x00\x00\x00\x00\x00\x00\x67\xff\x6f\xfe\x99\xff\xe8\xff\x6f\xfe\x6f\xfe\xae\xfe\x00\x00\x99\xff\xbc\xff\xbb\xff\xbd\xff\x00\x00\x6f\xfe\xba\xff\x6f\xfe\x76\xfe\x00\x00\x00\x00\x7a\xfe\x7c\xfe\x00\x00\x7d\xfe\x75\xfe\x00\x00\x00\x00\x00\x00\xbe\xff\xb4\xfe\x00\x00\x00\x00\x00\x00\x00\x00\x66\xff\x00\x00\xb9\xff\xe0\xff\x74\xfe\x00\x00\xe5\xff\xb9\xff\xe2\xff\x00\x00\xe4\xff\xb9\xff\xb9\xff\x00\x00\x00\x00\xc6\xff\x00\x00\xe6\xff\xc3\xff\xc5\xff\x00\x00\xde\xff\x00\x00\x32\xff\x00\x00\x3e\xff\x38\xff\x39\xff\x3a\xff\x00\x00\x00\x00\xf4\xfe\xf8\xfe\xf3\xfe\x00\x00\xf2\xfe\xf1\xfe\xf6\xfe\x00\x00\xb7\xfe\x60\xff\x00\x00\x00\x00\x00\x00\x00\x00\xd5\xfe\x00\x00\xd8\xfe\xd9\xfe\x00\x00\x00\x00\x9b\xff\xe3\xfe\xd0\xfe\xcf\xfe\xce\xfe\x00\x00\x00\x00\xde\xfe\xdd\xfe\xe9\xfe\xc1\xfe\xc0\xfe\x00\x00\x00\x00\x9d\xff\x25\xff\x24\xff\xa0\xfe\x00\x00\xaa\xfe\xab\xfe\xa6\xfe\x31\xff\x00\x00\x7a\xff\x00\x00\x8b\xff\x6d\xff\x00\x00\x9e\xfe\x16\xff\xc2\xfe\xdc\xfe\xed\xfe\xeb\xfe\xe2\xfe\x00\x00\xe5\xfe\x00\x00\x00\x00\xe0\xfe\x00\x00\x00\x00\xcd\xfe\xcc\xfe\x00\x00\xf9\xfe\xf5\xfe\x00\x00\x61\xff\x00\x00\xd4\xff\xd2\xff\x00\x00\xb9\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xd3\xff\x00\x00\x92\xff\x00\x00\x00\x00\x00\x00\xad\xfe\x00\x00\x00\x00\x70\xfe\x00\x00\x77\xfe\x78\xfe\x79\xfe\x96\xfe\x94\xff\x95\xff\xb3\xfe\x96\xff\x98\xff\x97\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xc7\xff\x00\x00\xc9\xff\xc4\xff\x33\xff\x00\x00\x5f\xff\xec\xfe\xd6\xfe\xda\xfe\xdb\xfe\xe8\xfe\x00\x00\x90\xff\xe1\xfe\x00\x00\xf7\xfe\xb9\xff\xcc\xff\xcb\xff\x00\x00\xe1\xff\x91\xff\xe3\xff\xc8\xff\xe7\xfe"#

happyCheck :: HappyAddr
happyCheck = HappyA# "\xff\xff\x04\x00\x05\x00\x0a\x00\x0f\x00\x0a\x00\x03\x00\x09\x00\x04\x00\x05\x00\x12\x00\x13\x00\x0a\x00\x24\x00\x0f\x00\x0a\x00\x0f\x00\x0a\x00\x10\x00\x0a\x00\x1f\x00\x10\x00\x0a\x00\x10\x00\x0a\x00\x04\x00\x05\x00\x02\x00\x07\x00\x65\x00\x1f\x00\x39\x00\x1f\x00\x0a\x00\x3a\x00\x3b\x00\x3c\x00\x29\x00\x2a\x00\x10\x00\x11\x00\x12\x00\x13\x00\x14\x00\x15\x00\x16\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x0a\x00\x51\x00\x0a\x00\x51\x00\x66\x00\x2d\x00\x10\x00\x26\x00\x43\x00\x0a\x00\x57\x00\x46\x00\x43\x00\x4b\x00\x05\x00\x10\x00\x5d\x00\x4a\x00\x4d\x00\x54\x00\x52\x00\x49\x00\x54\x00\x48\x00\x4a\x00\x52\x00\x49\x00\x48\x00\x54\x00\x55\x00\x48\x00\x54\x00\x52\x00\x54\x00\x55\x00\x60\x00\x5f\x00\x0a\x00\x5f\x00\x60\x00\x61\x00\x48\x00\x63\x00\x64\x00\x65\x00\x5f\x00\x60\x00\x61\x00\x24\x00\x63\x00\x64\x00\x54\x00\x55\x00\x47\x00\x2d\x00\x54\x00\x55\x00\x4b\x00\x44\x00\x43\x00\x5b\x00\x5c\x00\x01\x00\x60\x00\x61\x00\x04\x00\x49\x00\x06\x00\x4b\x00\x08\x00\x47\x00\x0a\x00\x0b\x00\x0c\x00\x0d\x00\x0e\x00\x0f\x00\x10\x00\x11\x00\x12\x00\x13\x00\x14\x00\x15\x00\x16\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x0a\x00\x43\x00\x24\x00\x54\x00\x46\x00\x25\x00\x26\x00\x27\x00\x28\x00\x29\x00\x4c\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x3b\x00\x3c\x00\x3d\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\x43\x00\x44\x00\x29\x00\x46\x00\x2d\x00\x48\x00\x2d\x00\x4a\x00\x0a\x00\x0b\x00\x4d\x00\x1d\x00\x54\x00\x55\x00\x51\x00\x54\x00\x0a\x00\x16\x00\x17\x00\x2a\x00\x2b\x00\x0a\x00\x43\x00\x5a\x00\x5b\x00\x5c\x00\x01\x00\x2a\x00\x2b\x00\x04\x00\x66\x00\x06\x00\x0a\x00\x08\x00\x0a\x00\x0a\x00\x0b\x00\x0c\x00\x0d\x00\x0e\x00\x54\x00\x10\x00\x11\x00\x12\x00\x13\x00\x14\x00\x15\x00\x16\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x05\x00\x62\x00\x66\x00\x64\x00\x43\x00\x54\x00\x0a\x00\x26\x00\x27\x00\x43\x00\x0e\x00\x2d\x00\x46\x00\x54\x00\x48\x00\x2a\x00\x4a\x00\x43\x00\x4c\x00\x1d\x00\x46\x00\x52\x00\x43\x00\x54\x00\x4a\x00\x46\x00\x4c\x00\x26\x00\x27\x00\x4a\x00\x66\x00\x4c\x00\x18\x00\x16\x00\x17\x00\x43\x00\x43\x00\x0a\x00\x46\x00\x46\x00\x2d\x00\x48\x00\x4a\x00\x4a\x00\x4c\x00\x0a\x00\x4d\x00\x0a\x00\x53\x00\x0e\x00\x2a\x00\x0a\x00\x0a\x00\x54\x00\x2a\x00\x2b\x00\x0a\x00\x54\x00\x18\x00\x5a\x00\x5b\x00\x5c\x00\x01\x00\x43\x00\x2a\x00\x04\x00\x46\x00\x06\x00\x48\x00\x08\x00\x51\x00\x0a\x00\x0b\x00\x0c\x00\x0d\x00\x0e\x00\x2a\x00\x10\x00\x11\x00\x12\x00\x13\x00\x14\x00\x15\x00\x16\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x54\x00\x52\x00\x43\x00\x54\x00\x54\x00\x46\x00\x06\x00\x26\x00\x27\x00\x0f\x00\x43\x00\x4c\x00\x43\x00\x46\x00\x54\x00\x46\x00\x43\x00\x43\x00\x0f\x00\x46\x00\x46\x00\x43\x00\x2b\x00\x05\x00\x46\x00\x1f\x00\x54\x00\x26\x00\x27\x00\x51\x00\x5d\x00\x44\x00\x45\x00\x55\x00\x1f\x00\x57\x00\x43\x00\x48\x00\x4b\x00\x46\x00\x67\x00\x48\x00\x49\x00\x4a\x00\x0a\x00\x2d\x00\x4d\x00\x54\x00\x55\x00\x0a\x00\x0b\x00\x0c\x00\x2a\x00\x0e\x00\x2c\x00\x2a\x00\x2a\x00\x2c\x00\x2c\x00\x5a\x00\x5b\x00\x5c\x00\x01\x00\x2d\x00\x2d\x00\x04\x00\x2a\x00\x06\x00\x2c\x00\x08\x00\x51\x00\x0a\x00\x0b\x00\x0c\x00\x0d\x00\x0e\x00\x25\x00\x10\x00\x11\x00\x12\x00\x13\x00\x14\x00\x15\x00\x16\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x05\x00\x0b\x00\x54\x00\x44\x00\x05\x00\x54\x00\x54\x00\x26\x00\x27\x00\x3a\x00\x4b\x00\x3c\x00\x05\x00\x44\x00\x43\x00\x44\x00\x54\x00\x46\x00\x5b\x00\x48\x00\x1f\x00\x5e\x00\x5f\x00\x60\x00\x61\x00\x62\x00\x63\x00\x64\x00\x65\x00\x54\x00\x05\x00\x68\x00\x51\x00\x56\x00\x49\x00\x2d\x00\x43\x00\x44\x00\x44\x00\x46\x00\x2d\x00\x48\x00\x0a\x00\x4a\x00\x2d\x00\x4b\x00\x4d\x00\x4b\x00\x10\x00\x0a\x00\x0b\x00\x0c\x00\x2d\x00\x0e\x00\x05\x00\x05\x00\x05\x00\x05\x00\x66\x00\x5a\x00\x5b\x00\x5c\x00\x01\x00\x21\x00\x2d\x00\x04\x00\x24\x00\x06\x00\x47\x00\x08\x00\x2d\x00\x0a\x00\x0b\x00\x0c\x00\x0d\x00\x0e\x00\x25\x00\x10\x00\x11\x00\x12\x00\x13\x00\x14\x00\x15\x00\x16\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x0a\x00\x54\x00\x2d\x00\x2d\x00\x2d\x00\x2d\x00\x10\x00\x26\x00\x27\x00\x44\x00\x08\x00\x09\x00\x0a\x00\x00\x00\x43\x00\x44\x00\x4b\x00\x46\x00\x5b\x00\x48\x00\x0e\x00\x5e\x00\x5f\x00\x60\x00\x61\x00\x62\x00\x63\x00\x64\x00\x65\x00\x10\x00\x11\x00\x68\x00\x52\x00\x56\x00\x54\x00\x49\x00\x43\x00\x44\x00\x44\x00\x46\x00\x1b\x00\x48\x00\x0a\x00\x4a\x00\x0a\x00\x0b\x00\x4d\x00\x2d\x00\x10\x00\x0a\x00\x0b\x00\x0c\x00\x49\x00\x0e\x00\x54\x00\x55\x00\x08\x00\x09\x00\x0a\x00\x5a\x00\x5b\x00\x5c\x00\x01\x00\x43\x00\x0a\x00\x04\x00\x2d\x00\x06\x00\x54\x00\x08\x00\x10\x00\x0a\x00\x0b\x00\x0c\x00\x0d\x00\x0e\x00\x25\x00\x10\x00\x11\x00\x12\x00\x13\x00\x14\x00\x15\x00\x16\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x24\x00\x2d\x00\x4b\x00\x08\x00\x09\x00\x0a\x00\x24\x00\x26\x00\x27\x00\x29\x00\x08\x00\x09\x00\x0a\x00\x2d\x00\x43\x00\x33\x00\x34\x00\x46\x00\x00\x00\x48\x00\x5b\x00\x5c\x00\x49\x00\x5e\x00\x5f\x00\x60\x00\x61\x00\x62\x00\x63\x00\x64\x00\x65\x00\x49\x00\x44\x00\x56\x00\x10\x00\x11\x00\x43\x00\x49\x00\x0a\x00\x46\x00\x2d\x00\x48\x00\x48\x00\x4a\x00\x10\x00\x1b\x00\x4d\x00\x2d\x00\x4e\x00\x4f\x00\x50\x00\x54\x00\x55\x00\x54\x00\x54\x00\x2d\x00\x08\x00\x09\x00\x0a\x00\x5a\x00\x5b\x00\x5c\x00\x01\x00\x4b\x00\x0a\x00\x04\x00\x2d\x00\x06\x00\x47\x00\x08\x00\x10\x00\x0a\x00\x0b\x00\x0c\x00\x0d\x00\x0e\x00\x24\x00\x10\x00\x11\x00\x12\x00\x13\x00\x14\x00\x15\x00\x16\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x53\x00\x2d\x00\x58\x00\x59\x00\x5a\x00\x00\x00\x59\x00\x26\x00\x27\x00\x5b\x00\x5c\x00\x4a\x00\x5e\x00\x5f\x00\x60\x00\x61\x00\x62\x00\x63\x00\x64\x00\x65\x00\x5b\x00\x10\x00\x0a\x00\x5e\x00\x5f\x00\x60\x00\x61\x00\x62\x00\x63\x00\x64\x00\x65\x00\x5e\x00\x1b\x00\x60\x00\x61\x00\x62\x00\x43\x00\x49\x00\x65\x00\x46\x00\x29\x00\x48\x00\x44\x00\x4a\x00\x2d\x00\x0a\x00\x4d\x00\x04\x00\x0a\x00\x49\x00\x07\x00\x10\x00\x2d\x00\x54\x00\x10\x00\x0c\x00\x4b\x00\x53\x00\x0a\x00\x5a\x00\x5b\x00\x5c\x00\x01\x00\x59\x00\x10\x00\x04\x00\x54\x00\x06\x00\x19\x00\x08\x00\x1b\x00\x0a\x00\x0b\x00\x0c\x00\x0d\x00\x0e\x00\x48\x00\x10\x00\x11\x00\x12\x00\x13\x00\x14\x00\x15\x00\x16\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x54\x00\x55\x00\x00\x00\x16\x00\x17\x00\x44\x00\x5b\x00\x26\x00\x27\x00\x5e\x00\x5f\x00\x60\x00\x61\x00\x62\x00\x63\x00\x64\x00\x65\x00\x24\x00\x10\x00\x24\x00\x53\x00\x0a\x00\x53\x00\x44\x00\x0a\x00\x0a\x00\x59\x00\x44\x00\x59\x00\x1b\x00\x10\x00\x10\x00\x33\x00\x34\x00\x33\x00\x34\x00\x43\x00\x24\x00\x53\x00\x46\x00\x24\x00\x48\x00\x53\x00\x4a\x00\x59\x00\x0a\x00\x4d\x00\x42\x00\x59\x00\x44\x00\x0a\x00\x44\x00\x45\x00\x54\x00\x49\x00\x46\x00\x49\x00\x48\x00\x53\x00\x5a\x00\x5b\x00\x5c\x00\x01\x00\x54\x00\x59\x00\x04\x00\x51\x00\x06\x00\x52\x00\x08\x00\x54\x00\x0a\x00\x0b\x00\x0c\x00\x0d\x00\x0e\x00\x0a\x00\x10\x00\x11\x00\x12\x00\x13\x00\x14\x00\x15\x00\x16\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x29\x00\x16\x00\x54\x00\x55\x00\x2d\x00\x57\x00\x47\x00\x26\x00\x27\x00\x54\x00\x00\x00\x5d\x00\x02\x00\x03\x00\x04\x00\x24\x00\x50\x00\x07\x00\x52\x00\x52\x00\x54\x00\x54\x00\x0c\x00\x43\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x29\x00\x2a\x00\x37\x00\x19\x00\x43\x00\x1b\x00\x25\x00\x46\x00\x3d\x00\x48\x00\x3f\x00\x4a\x00\x0a\x00\x0b\x00\x4d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x0a\x00\x54\x00\x4b\x00\x4c\x00\x54\x00\x55\x00\x39\x00\x5a\x00\x5b\x00\x5c\x00\x01\x00\x49\x00\x52\x00\x04\x00\x54\x00\x06\x00\x48\x00\x08\x00\x44\x00\x0a\x00\x0b\x00\x0c\x00\x0d\x00\x0e\x00\x10\x00\x10\x00\x11\x00\x12\x00\x13\x00\x14\x00\x15\x00\x16\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x37\x00\x38\x00\x04\x00\x58\x00\x59\x00\x07\x00\x0a\x00\x26\x00\x27\x00\x0a\x00\x0c\x00\x04\x00\x51\x00\x0a\x00\x07\x00\x24\x00\x55\x00\x56\x00\x57\x00\x0c\x00\x52\x00\x53\x00\x54\x00\x19\x00\x2d\x00\x1b\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x19\x00\x0a\x00\x1b\x00\x44\x00\x43\x00\x44\x00\x44\x00\x46\x00\x3d\x00\x48\x00\x3f\x00\x4a\x00\x37\x00\x38\x00\x4d\x00\x37\x00\x38\x00\x0a\x00\x0b\x00\x0c\x00\x0a\x00\x0e\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x5a\x00\x5b\x00\x5c\x00\x01\x00\x58\x00\x59\x00\x04\x00\x54\x00\x06\x00\x24\x00\x08\x00\x54\x00\x0a\x00\x0b\x00\x0c\x00\x0d\x00\x0e\x00\x25\x00\x10\x00\x11\x00\x12\x00\x13\x00\x14\x00\x15\x00\x16\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x46\x00\x47\x00\x48\x00\x43\x00\x58\x00\x59\x00\x5a\x00\x26\x00\x27\x00\x37\x00\x38\x00\x51\x00\x37\x00\x38\x00\x43\x00\x24\x00\x53\x00\x46\x00\x24\x00\x48\x00\x52\x00\x53\x00\x54\x00\x51\x00\x2d\x00\x39\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x49\x00\x1f\x00\x20\x00\x21\x00\x43\x00\x23\x00\x24\x00\x46\x00\x3d\x00\x48\x00\x3f\x00\x4a\x00\x48\x00\x24\x00\x4d\x00\x2d\x00\x40\x00\x41\x00\x4e\x00\x4f\x00\x50\x00\x54\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x5a\x00\x5b\x00\x5c\x00\x01\x00\x58\x00\x59\x00\x04\x00\x49\x00\x06\x00\x58\x00\x08\x00\x51\x00\x0a\x00\x0b\x00\x0c\x00\x0d\x00\x0e\x00\x09\x00\x10\x00\x11\x00\x12\x00\x13\x00\x14\x00\x15\x00\x16\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x1e\x00\x1f\x00\x20\x00\x21\x00\x22\x00\x23\x00\x24\x00\x26\x00\x27\x00\x44\x00\x24\x00\x12\x00\x13\x00\x37\x00\x38\x00\x2d\x00\x14\x00\x15\x00\x24\x00\x2d\x00\x44\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x2d\x00\x0d\x00\x0e\x00\x14\x00\x15\x00\x32\x00\x33\x00\x34\x00\x3d\x00\x43\x00\x3f\x00\x0a\x00\x46\x00\x4b\x00\x48\x00\x47\x00\x4a\x00\x16\x00\x17\x00\x4d\x00\x14\x00\x15\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x16\x00\x17\x00\x44\x00\x4b\x00\x4c\x00\x5a\x00\x5b\x00\x5c\x00\x0a\x00\x0b\x00\x0c\x00\x0d\x00\x0e\x00\x53\x00\x10\x00\x11\x00\x12\x00\x13\x00\x14\x00\x15\x00\x16\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x48\x00\x20\x00\x21\x00\x22\x00\x23\x00\x4b\x00\x25\x00\x26\x00\x49\x00\x28\x00\x29\x00\x49\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x3b\x00\x3c\x00\x3d\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\x43\x00\x0a\x00\x44\x00\x46\x00\x44\x00\x48\x00\x4b\x00\x10\x00\x11\x00\x12\x00\x13\x00\x14\x00\x14\x00\x15\x00\x51\x00\x44\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x44\x00\x1e\x00\x59\x00\x0a\x00\x5b\x00\x5c\x00\x49\x00\x0e\x00\x49\x00\x10\x00\x11\x00\x12\x00\x13\x00\x14\x00\x15\x00\x16\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x51\x00\x1e\x00\x16\x00\x17\x00\x14\x00\x15\x00\x14\x00\x15\x00\x25\x00\x26\x00\x53\x00\x28\x00\x29\x00\x54\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x3b\x00\x3c\x00\x3d\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\x43\x00\x44\x00\x07\x00\x46\x00\x0d\x00\x0e\x00\x28\x00\x4a\x00\x28\x00\x4c\x00\x37\x00\x38\x00\x37\x00\x38\x00\x51\x00\x54\x00\x1e\x00\x1f\x00\x20\x00\x21\x00\x22\x00\x23\x00\x24\x00\x49\x00\x5b\x00\x5c\x00\x0a\x00\x0b\x00\x0c\x00\x0d\x00\x0e\x00\x2d\x00\x10\x00\x11\x00\x12\x00\x13\x00\x14\x00\x15\x00\x16\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x40\x00\x41\x00\x0a\x00\x58\x00\x59\x00\x47\x00\x0e\x00\x0a\x00\x10\x00\x11\x00\x12\x00\x13\x00\x14\x00\x15\x00\x16\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x0a\x00\x1e\x00\x3d\x00\x3e\x00\x00\x00\x24\x00\x02\x00\x03\x00\x04\x00\x26\x00\x24\x00\x07\x00\x3d\x00\x3e\x00\x24\x00\x43\x00\x0c\x00\x49\x00\x46\x00\x2d\x00\x48\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x58\x00\x59\x00\x19\x00\x54\x00\x1b\x00\x16\x00\x17\x00\x49\x00\x3d\x00\x54\x00\x3f\x00\x43\x00\x5b\x00\x5c\x00\x46\x00\x37\x00\x38\x00\x24\x00\x4a\x00\x54\x00\x4c\x00\x4b\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x14\x00\x15\x00\x14\x00\x15\x00\x14\x00\x15\x00\x0a\x00\x49\x00\x5b\x00\x5c\x00\x0e\x00\x49\x00\x10\x00\x11\x00\x12\x00\x13\x00\x14\x00\x15\x00\x16\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x24\x00\x1e\x00\x14\x00\x15\x00\x0a\x00\x3d\x00\x3e\x00\x14\x00\x15\x00\x26\x00\x10\x00\x11\x00\x12\x00\x13\x00\x14\x00\x15\x00\x16\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x1e\x00\x1f\x00\x20\x00\x21\x00\x22\x00\x23\x00\x24\x00\x26\x00\x3d\x00\x3e\x00\x24\x00\x14\x00\x15\x00\x43\x00\x24\x00\x2d\x00\x46\x00\x4b\x00\x24\x00\x2d\x00\x44\x00\x24\x00\x4c\x00\x24\x00\x32\x00\x33\x00\x34\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x0a\x00\x49\x00\x5b\x00\x5c\x00\x24\x00\x24\x00\x48\x00\x49\x00\x3d\x00\x58\x00\x3f\x00\x49\x00\x4b\x00\x47\x00\x4b\x00\x4c\x00\x44\x00\x44\x00\x0a\x00\x53\x00\x24\x00\x24\x00\x4b\x00\x4c\x00\x54\x00\x5b\x00\x5c\x00\x25\x00\x26\x00\x54\x00\x28\x00\x29\x00\x49\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x3b\x00\x3c\x00\x3d\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\x43\x00\x44\x00\x0a\x00\x46\x00\x54\x00\x53\x00\x24\x00\x4a\x00\x44\x00\x4c\x00\x4b\x00\x25\x00\x26\x00\x24\x00\x51\x00\x18\x00\x0f\x00\x0d\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x1d\x00\x6c\x00\x16\x00\x2d\x00\x25\x00\x26\x00\x39\x00\x28\x00\x29\x00\x4a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x3b\x00\x3c\x00\x3d\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\x2d\x00\x6a\x00\x67\x00\x69\x00\x20\x00\x21\x00\x22\x00\x23\x00\x66\x00\x25\x00\x26\x00\x2d\x00\x28\x00\x29\x00\x51\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x3b\x00\x3c\x00\x3d\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\x1e\x00\x1f\x00\x20\x00\x21\x00\x22\x00\x23\x00\x24\x00\x1d\x00\x33\x00\x4a\x00\x0f\x00\x6b\x00\x6b\x00\x33\x00\x51\x00\x2d\x00\x6b\x00\x54\x00\x20\x00\x21\x00\x22\x00\x23\x00\x59\x00\x25\x00\x26\x00\x6b\x00\x28\x00\x29\x00\x6b\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x3b\x00\x3c\x00\x3d\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\x1e\x00\x1f\x00\x20\x00\x21\x00\x22\x00\x23\x00\x24\x00\x6b\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x51\x00\x2d\x00\xff\xff\x54\x00\x20\x00\x21\x00\x22\x00\x23\x00\x59\x00\x25\x00\x26\x00\xff\xff\x28\x00\x29\x00\xff\xff\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x3b\x00\x3c\x00\x3d\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\x1a\x00\x44\x00\x1c\x00\xff\xff\x1e\x00\x1f\x00\x20\x00\x21\x00\x22\x00\x23\x00\x24\x00\xff\xff\xff\xff\xff\xff\x51\x00\x20\x00\x21\x00\x22\x00\x23\x00\x2d\x00\x25\x00\x26\x00\x59\x00\x28\x00\x29\x00\xff\xff\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x3b\x00\x3c\x00\x3d\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\xff\xff\x1f\x00\x20\x00\x21\x00\xff\xff\x23\x00\x24\x00\x25\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x51\x00\x2d\x00\xff\xff\x54\x00\x20\x00\x21\x00\x22\x00\x23\x00\x59\x00\x25\x00\x26\x00\xff\xff\x28\x00\x29\x00\xff\xff\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x3b\x00\x3c\x00\x3d\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\x1a\x00\xff\xff\x1c\x00\xff\xff\x1e\x00\x1f\x00\x20\x00\x21\x00\x22\x00\x23\x00\x24\x00\xff\xff\xff\xff\xff\xff\x51\x00\x20\x00\x21\x00\x22\x00\x23\x00\x2d\x00\x25\x00\x26\x00\x59\x00\x28\x00\x29\x00\xff\xff\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x3b\x00\x3c\x00\x3d\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\x1a\x00\xff\xff\x1c\x00\xff\xff\x1e\x00\x1f\x00\x20\x00\x21\x00\x22\x00\x23\x00\x24\x00\xff\xff\xff\xff\xff\xff\x51\x00\x20\x00\x21\x00\x22\x00\x23\x00\x2d\x00\x25\x00\x26\x00\x59\x00\x28\x00\x29\x00\xff\xff\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x3b\x00\x3c\x00\x3d\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\x1a\x00\xff\xff\x1c\x00\xff\xff\x1e\x00\x1f\x00\x20\x00\x21\x00\x22\x00\x23\x00\x24\x00\xff\xff\xff\xff\xff\xff\x51\x00\x20\x00\x21\x00\x22\x00\x23\x00\x2d\x00\x25\x00\x26\x00\x59\x00\x28\x00\x29\x00\xff\xff\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x3b\x00\x3c\x00\x3d\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\x1a\x00\xff\xff\x1c\x00\xff\xff\x1e\x00\x1f\x00\x20\x00\x21\x00\x22\x00\x23\x00\x24\x00\xff\xff\xff\xff\xff\xff\x51\x00\x20\x00\x21\x00\x22\x00\x23\x00\x2d\x00\x25\x00\x26\x00\x59\x00\x28\x00\x29\x00\xff\xff\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x3b\x00\x3c\x00\x3d\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\x1a\x00\xff\xff\x1c\x00\xff\xff\x1e\x00\x1f\x00\x20\x00\x21\x00\x22\x00\x23\x00\x24\x00\xff\xff\xff\xff\xff\xff\x51\x00\xff\xff\xff\xff\x25\x00\x26\x00\x2d\x00\x28\x00\x29\x00\x59\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x3b\x00\x3c\x00\x3d\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\x1a\x00\xff\xff\x1c\x00\xff\xff\x1e\x00\x1f\x00\x20\x00\x21\x00\x22\x00\x23\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x25\x00\x26\x00\x2d\x00\x28\x00\x29\x00\x59\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x3b\x00\x3c\x00\x3d\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x25\x00\x26\x00\xff\xff\x28\x00\x29\x00\x51\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x3b\x00\x3c\x00\x3d\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x25\x00\x26\x00\xff\xff\x28\x00\x29\x00\x51\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x3b\x00\x3c\x00\x3d\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x25\x00\x26\x00\xff\xff\x28\x00\x29\x00\x51\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x3b\x00\x3c\x00\x3d\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\xff\xff\xff\xff\xff\xff\xff\xff\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x24\x00\x2d\x00\x51\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x2d\x00\xff\xff\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x3d\x00\xff\xff\x3f\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x3d\x00\xff\xff\x3f\x00\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x24\x00\xff\xff\xff\xff\x4b\x00\x4c\x00\x4d\x00\xff\xff\x4f\x00\xff\xff\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x3d\x00\xff\xff\x3f\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x24\x00\x4b\x00\x4c\x00\xff\xff\xff\xff\xff\xff\x3d\x00\xff\xff\x3f\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\xff\xff\xff\xff\x24\x00\x4b\x00\x4c\x00\xff\xff\xff\xff\xff\xff\x3d\x00\xff\xff\x3f\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\xff\xff\xff\xff\x24\x00\x4b\x00\x4c\x00\xff\xff\xff\xff\xff\xff\x3d\x00\xff\xff\x3f\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\xff\xff\xff\xff\x24\x00\x4b\x00\x4c\x00\xff\xff\xff\xff\xff\xff\x3d\x00\xff\xff\x3f\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\xff\xff\xff\xff\x24\x00\x4b\x00\x4c\x00\xff\xff\xff\xff\xff\xff\x3d\x00\xff\xff\x3f\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\xff\xff\xff\xff\x24\x00\x4b\x00\x4c\x00\xff\xff\xff\xff\xff\xff\x3d\x00\xff\xff\x3f\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\xff\xff\xff\xff\x24\x00\x4b\x00\x4c\x00\xff\xff\xff\xff\xff\xff\x3d\x00\xff\xff\x3f\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\xff\xff\xff\xff\x24\x00\x4b\x00\x4c\x00\xff\xff\xff\xff\xff\xff\x3d\x00\xff\xff\x3f\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\xff\xff\xff\xff\x24\x00\x4b\x00\x4c\x00\xff\xff\xff\xff\xff\xff\x3d\x00\xff\xff\x3f\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\xff\xff\xff\xff\x24\x00\x4b\x00\x4c\x00\xff\xff\xff\xff\xff\xff\x3d\x00\xff\xff\x3f\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\xff\xff\xff\xff\x24\x00\x4b\x00\x4c\x00\xff\xff\xff\xff\xff\xff\x3d\x00\xff\xff\x3f\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\xff\xff\xff\xff\x24\x00\x4b\x00\x4c\x00\xff\xff\xff\xff\xff\xff\x3d\x00\xff\xff\x3f\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\xff\xff\xff\xff\x24\x00\x4b\x00\x4c\x00\xff\xff\xff\xff\xff\xff\x3d\x00\xff\xff\x3f\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\xff\xff\xff\xff\x24\x00\x4b\x00\x4c\x00\xff\xff\xff\xff\xff\xff\x3d\x00\xff\xff\x3f\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\xff\xff\xff\xff\x24\x00\x4b\x00\x4c\x00\xff\xff\xff\xff\xff\xff\x3d\x00\xff\xff\x3f\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\xff\xff\xff\xff\x24\x00\x4b\x00\x4c\x00\xff\xff\xff\xff\xff\xff\x3d\x00\xff\xff\x3f\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\xff\xff\xff\xff\x24\x00\x4b\x00\x4c\x00\xff\xff\xff\xff\xff\xff\x3d\x00\xff\xff\x3f\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\xff\xff\xff\xff\x24\x00\x4b\x00\x4c\x00\xff\xff\xff\xff\xff\xff\x3d\x00\xff\xff\x3f\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\xff\xff\xff\xff\x24\x00\x4b\x00\x4c\x00\xff\xff\xff\xff\xff\xff\x3d\x00\xff\xff\x3f\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\xff\xff\xff\xff\x24\x00\x4b\x00\x4c\x00\xff\xff\xff\xff\xff\xff\x3d\x00\xff\xff\x3f\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\xff\xff\xff\xff\x24\x00\x4b\x00\x4c\x00\xff\xff\xff\xff\xff\xff\x3d\x00\xff\xff\x3f\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\xff\xff\xff\xff\x24\x00\x4b\x00\x4c\x00\xff\xff\xff\xff\xff\xff\x3d\x00\xff\xff\x3f\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\xff\xff\xff\xff\x24\x00\x4b\x00\x4c\x00\xff\xff\xff\xff\xff\xff\x3d\x00\xff\xff\x3f\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\xff\xff\xff\xff\x24\x00\x4b\x00\x4c\x00\xff\xff\xff\xff\xff\xff\x3d\x00\xff\xff\x3f\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\xff\xff\xff\xff\x24\x00\x4b\x00\x4c\x00\xff\xff\xff\xff\xff\xff\x3d\x00\xff\xff\x3f\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\xff\xff\xff\xff\x24\x00\x4b\x00\x4c\x00\xff\xff\xff\xff\xff\xff\x3d\x00\xff\xff\x3f\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\xff\xff\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\xff\xff\xff\xff\x24\x00\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x24\x00\xff\xff\x33\x00\x34\x00\xff\xff\x4b\x00\x4c\x00\xff\xff\x3d\x00\x2d\x00\x3f\x00\x24\x00\xff\xff\xff\xff\x32\x00\x33\x00\x34\x00\x42\x00\x43\x00\x44\x00\x24\x00\xff\xff\x4b\x00\x4c\x00\x49\x00\xff\xff\x33\x00\x34\x00\xff\xff\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x33\x00\x34\x00\xff\xff\x24\x00\x4b\x00\x4c\x00\x42\x00\x43\x00\x44\x00\x33\x00\x34\x00\xff\xff\xff\xff\x49\x00\xff\xff\x42\x00\xff\xff\x44\x00\x33\x00\x34\x00\xff\xff\xff\xff\x49\x00\xff\xff\x42\x00\xff\xff\x44\x00\xff\xff\xff\xff\xff\xff\xff\xff\x49\x00\xff\xff\x42\x00\xff\xff\x44\x00\xff\xff\xff\xff\x25\x00\x26\x00\x49\x00\x28\x00\x29\x00\xff\xff\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x3b\x00\x3c\x00\x3d\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\x25\x00\x26\x00\xff\xff\x28\x00\x29\x00\xff\xff\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x3b\x00\xff\xff\x3d\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\x25\x00\x26\x00\xff\xff\x28\x00\x29\x00\xff\xff\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x3b\x00\xff\xff\xff\xff\x3e\x00\x3f\x00\x40\x00\xff\xff\x42\x00\x25\x00\x26\x00\xff\xff\x28\x00\x29\x00\xff\xff\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x3b\x00\xff\xff\xff\xff\x3e\x00\x3f\x00\x40\x00\x25\x00\x26\x00\xff\xff\xff\xff\x29\x00\xff\xff\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x39\x00\x3a\x00\x3b\x00\xff\xff\xff\xff\x3e\x00\x3f\x00\x40\x00\x00\x00\xff\xff\x02\x00\x03\x00\x04\x00\xff\xff\x00\x00\x07\x00\x02\x00\x03\x00\x04\x00\xff\xff\x0c\x00\x07\x00\xff\xff\xff\xff\xff\xff\x00\x00\x0c\x00\x02\x00\x03\x00\x04\x00\xff\xff\xff\xff\x07\x00\x19\x00\xff\xff\x1b\x00\xff\xff\x0c\x00\xff\xff\x19\x00\xff\xff\x1b\x00\x00\x00\x01\x00\xff\xff\xff\xff\x04\x00\xff\xff\xff\xff\x07\x00\x19\x00\x00\x00\x1b\x00\x02\x00\x0c\x00\x04\x00\xff\xff\xff\xff\x07\x00\xff\xff\xff\xff\xff\xff\xff\xff\x0c\x00\xff\xff\xff\xff\xff\xff\x19\x00\x00\x00\x1b\x00\x02\x00\xff\xff\x04\x00\xff\xff\xff\xff\x07\x00\x19\x00\x00\x00\x1b\x00\xff\xff\x0c\x00\x04\x00\xff\xff\xff\xff\x07\x00\xff\xff\xff\xff\xff\xff\xff\xff\x0c\x00\xff\xff\xff\xff\xff\xff\x19\x00\xff\xff\x1b\x00\xff\xff\xff\xff\x25\x00\x26\x00\xff\xff\xff\xff\x19\x00\xff\xff\x1b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x39\x00\x3a\x00\x3b\x00\x1a\x00\xff\xff\x1c\x00\xff\xff\x1e\x00\x1f\x00\x20\x00\x21\x00\x22\x00\x23\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x1a\x00\xff\xff\x1c\x00\x2d\x00\x1e\x00\x1f\x00\x20\x00\x21\x00\x22\x00\x23\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x1c\x00\x2d\x00\x1e\x00\x1f\x00\x20\x00\x21\x00\x22\x00\x23\x00\x24\x00\xff\xff\xff\xff\xff\xff\x28\x00\xff\xff\xff\xff\xff\xff\x1c\x00\x2d\x00\x1e\x00\x1f\x00\x20\x00\x21\x00\x22\x00\x23\x00\x24\x00\xff\xff\xff\xff\xff\xff\x28\x00\xff\xff\xff\xff\xff\xff\x1c\x00\x2d\x00\x1e\x00\x1f\x00\x20\x00\x21\x00\x22\x00\x23\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x1c\x00\x2d\x00\x1e\x00\x1f\x00\x20\x00\x21\x00\x22\x00\x23\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x1c\x00\x2d\x00\x1e\x00\x1f\x00\x20\x00\x21\x00\x22\x00\x23\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x1c\x00\x2d\x00\x1e\x00\x1f\x00\x20\x00\x21\x00\x22\x00\x23\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x1c\x00\x2d\x00\x1e\x00\x1f\x00\x20\x00\x21\x00\x22\x00\x23\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x1c\x00\x2d\x00\x1e\x00\x1f\x00\x20\x00\x21\x00\x22\x00\x23\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x1c\x00\x2d\x00\x1e\x00\x1f\x00\x20\x00\x21\x00\x22\x00\x23\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x1c\x00\x2d\x00\x1e\x00\x1f\x00\x20\x00\x21\x00\x22\x00\x23\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x1c\x00\x2d\x00\x1e\x00\x1f\x00\x20\x00\x21\x00\x22\x00\x23\x00\x24\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x2d\x00\x10\x00\x11\x00\x12\x00\x13\x00\x14\x00\x15\x00\x16\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff"#

happyTable :: HappyAddr
happyTable = HappyA# "\x00\x00\x31\x00\x32\x00\x22\x01\xba\x00\x3e\x00\x89\x02\x96\x01\x31\x00\x32\x00\xe6\x00\xe7\x00\x3e\x00\x91\x01\xba\x00\x91\x00\xba\x00\x3e\x00\x8c\x00\x85\x01\xf0\x00\x92\x00\xea\x02\x8c\x00\x1d\x01\x51\x00\x8d\x02\x87\x01\x8e\x02\x09\x00\xf0\x00\x5e\x01\xf0\x00\x15\x00\xb0\x00\xb1\x00\xb2\x00\x25\x01\x26\x01\x16\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x20\x00\x21\x00\x22\x00\x23\x00\x24\x00\xab\x00\x5f\x01\x29\x01\xb3\x00\xff\xff\x3c\x00\xac\x00\x25\x00\x3f\x00\x91\x00\x92\x01\x40\x00\x37\x01\xe8\x00\x52\x01\x92\x00\x93\x01\x33\x00\x41\x00\xdb\x01\xe9\x00\x8d\x00\xe4\x00\x61\x01\x33\x00\x34\x00\xd8\x01\xa0\x01\x15\x01\x16\x01\x3a\x01\x75\x02\x34\x00\x15\x01\x16\x01\x23\x01\x42\x00\x2e\x01\x35\x00\x36\x00\x37\x00\x26\x00\x38\x00\x39\x00\x09\x00\x35\x00\x36\x00\x37\x00\xf7\x01\x38\x00\x39\x00\x15\x01\x16\x01\xfe\xfe\x53\x01\x15\x01\x16\x01\xfe\xfe\xfc\x01\x2a\x01\x27\x00\x28\x00\x50\x00\x8f\x02\x90\x02\x51\x00\x3b\x01\x52\x00\x3c\x01\x53\x00\x93\x00\x3e\x00\x54\x00\x55\x00\x56\x00\x57\x00\xba\x00\x58\x00\x59\x00\x5a\x00\x5b\x00\x5c\x00\x5d\x00\x5e\x00\x5f\x00\x60\x00\x61\x00\x62\x00\x63\x00\x64\x00\x65\x00\x66\x00\xbb\x00\x3e\x00\x2f\x01\xc5\x02\xf8\x01\xa7\x00\xbc\x00\xbd\x00\x68\x00\xbe\x00\xbf\x00\xa8\x00\xc0\x00\xc1\x00\xc2\x00\xc3\x00\xc4\x00\xc5\x00\xc6\x00\xc7\x00\xc8\x00\xc9\x00\xca\x00\xcb\x00\xcc\x00\xcd\x00\xce\x00\xcf\x00\xd0\x00\xd1\x00\xd2\x00\xd3\x00\xd4\x00\xd5\x00\xd6\x00\xd7\x00\x69\x00\xd8\x00\x99\x00\x6a\x00\x09\x00\x6b\x00\x8a\x00\x6c\x00\xeb\x00\x54\x00\x6d\x00\x27\x01\x15\x01\x16\x01\xd9\x00\xc6\x02\xa5\x00\x3c\x01\xcf\x01\xa1\x00\xa2\x00\x21\x02\x35\x02\x6e\x00\x6f\x00\x70\x00\x50\x00\xa1\x00\xd2\x01\x51\x00\xff\xff\x52\x00\x1c\x01\x53\x00\xa5\x00\x3e\x00\x54\x00\x55\x00\x56\x00\x57\x00\x1f\x01\x58\x00\x59\x00\x5a\x00\x5b\x00\x5c\x00\x5d\x00\x5e\x00\x5f\x00\x60\x00\x61\x00\x62\x00\x63\x00\x64\x00\x65\x00\x66\x00\x40\x02\x34\x01\xff\xff\x35\x01\x19\x01\xa3\x00\x3e\x00\x67\x00\x68\x00\xa6\x00\x57\x00\x3c\x00\xa7\x00\xa3\x00\xec\x00\x59\x02\xe6\x00\xa6\x00\xa8\x00\x17\x01\xa7\x00\x46\x01\xa6\x00\xe4\x00\xe6\x00\xa7\x00\xa8\x00\x8d\x00\x8e\x00\xe6\x00\xff\xff\xa8\x00\x2f\x01\x3c\x01\x45\x01\xa6\x00\x69\x00\xa5\x00\xa7\x00\x6a\x00\x53\x01\x6b\x00\xe6\x00\x6c\x00\xa8\x00\x3e\x00\x6d\x00\x3e\x00\xa0\x00\x57\x00\x30\x01\x3e\x00\x42\x02\xe1\x00\xa1\x00\x28\x02\x3e\x00\xa3\x00\x2b\x01\x6e\x00\x6f\x00\x70\x00\x50\x00\x98\x00\x4f\x02\x51\x00\x7e\x00\x52\x00\x9d\x00\x53\x00\x8f\x00\x3e\x00\x54\x00\x55\x00\x56\x00\x57\x00\x2c\x01\x58\x00\x59\x00\x5a\x00\x5b\x00\x5c\x00\x5d\x00\x5e\x00\x5f\x00\x60\x00\x61\x00\x62\x00\x63\x00\x64\x00\x65\x00\x66\x00\xa3\x00\x46\x01\xa6\x00\xe4\x00\xa3\x00\xa7\x00\x71\x02\x67\x00\x68\x00\xba\x00\x98\x00\xa8\x00\x3f\x00\x7e\x00\xa3\x00\x40\x00\x55\x01\x55\x01\xba\x00\x56\x01\x56\x01\x55\x01\x9f\x00\x81\x02\x56\x01\xf0\x00\xa3\x00\x8d\x00\xeb\x01\xcb\x01\xe7\x02\xc0\x01\xc1\x01\xcc\x01\xf0\x00\xb3\x02\x69\x00\x89\x00\xc2\x01\x6a\x00\xe8\x02\x6b\x00\xb0\x00\x6c\x00\xe3\x01\x72\x02\x6d\x00\x15\x01\x16\x01\x95\x00\x7a\x00\x7b\x00\x4a\x02\x57\x00\x57\x02\x4a\x02\x4a\x02\x4e\x02\x4b\x02\x6e\x00\x6f\x00\x70\x00\x50\x00\x53\x01\x09\x00\x51\x00\x4a\x02\x52\x00\x6b\x02\x53\x00\x8f\x00\x3e\x00\x54\x00\x55\x00\x56\x00\x57\x00\x7c\x00\x58\x00\x59\x00\x5a\x00\x5b\x00\x5c\x00\x5d\x00\x5e\x00\x5f\x00\x60\x00\x61\x00\x62\x00\x63\x00\x64\x00\x65\x00\x66\x00\x7f\x02\x32\x02\xa3\x00\xdc\x01\x7a\x02\xa3\x00\xa3\x00\x67\x00\x68\x00\xb0\x00\xdd\x01\xfd\x01\x73\x02\x57\x01\x7d\x00\x96\x00\xa3\x00\x7e\x00\x5a\x02\x7f\x00\xe4\x01\x0c\x00\x0d\x00\x0e\x00\x0f\x00\x10\x00\x11\x00\x12\x00\x13\x00\x1f\x01\x6f\x02\x5b\x02\xb3\x00\x80\x00\xe2\x01\x33\x02\x69\x00\xc4\x01\x51\x02\x6a\x00\x53\x01\x6b\x00\xab\x00\x6c\x00\x53\x01\x52\x02\x6d\x00\xe0\x01\xac\x00\x3e\x00\x7a\x00\x7b\x00\x53\x01\x57\x00\x6e\x02\xd9\x02\xf5\x02\x0c\x03\xff\xff\x6e\x00\x6f\x00\x70\x00\x50\x00\xd5\x01\x09\x00\x51\x00\x77\x00\x52\x00\xdf\x01\x53\x00\x53\x01\x3e\x00\x54\x00\x55\x00\x56\x00\x57\x00\x7c\x00\x58\x00\x59\x00\x5a\x00\x5b\x00\x5c\x00\x5d\x00\x5e\x00\x5f\x00\x60\x00\x61\x00\x62\x00\x63\x00\x64\x00\x65\x00\x66\x00\xb5\x00\xde\x01\x53\x01\x53\x01\x53\x01\x53\x01\x92\x00\x67\x00\x68\x00\xc2\x02\x39\x00\x3a\x00\x3b\x00\x37\x02\x7d\x00\x96\x00\xc3\x02\x7e\x00\x5a\x02\x7f\x00\x57\x00\x0c\x00\x0d\x00\x0e\x00\x0f\x00\x10\x00\x11\x00\x12\x00\x13\x00\x38\x02\x39\x02\xe6\x02\xe3\x00\x80\x00\xe4\x00\xda\x01\x69\x00\x9f\x01\x9d\x01\x6a\x00\x3a\x02\x6b\x00\xab\x00\x6c\x00\x4e\x01\x4f\x01\x6d\x00\x3c\x00\xac\x00\x3e\x00\x7a\x00\x7b\x00\xd9\x01\x57\x00\x15\x01\x16\x01\x20\x01\x3a\x00\x3b\x00\x6e\x00\x6f\x00\x70\x00\x50\x00\xca\x01\x3e\x00\x51\x00\x09\x00\x52\x00\xd2\x01\x53\x00\x8c\x00\x3e\x00\x54\x00\x55\x00\x56\x00\x57\x00\x7c\x00\x58\x00\x59\x00\x5a\x00\x5b\x00\x5c\x00\x5d\x00\x5e\x00\x5f\x00\x60\x00\x61\x00\x62\x00\x63\x00\x64\x00\x65\x00\x66\x00\xa5\x02\x3c\x00\xc8\x01\x1a\x01\x3a\x00\x3b\x00\xb2\xfe\x67\x00\x68\x00\x98\x00\x80\x02\x3a\x00\x3b\x00\x8a\x00\x7d\x00\x49\x00\x0f\x02\x7e\x00\x37\x02\x7f\x00\x0a\x00\x0b\x00\xcb\x01\x0c\x00\x0d\x00\x0e\x00\x0f\x00\x10\x00\x11\x00\x12\x00\x13\x00\xc9\x01\xbe\x02\x80\x00\x38\x02\x7d\x02\x69\x00\x12\x02\x91\x00\x6a\x00\x3c\x00\x6b\x00\x42\x01\x6c\x00\x92\x00\x3a\x02\x6d\x00\x3c\x00\x43\x01\x44\x01\x45\x01\x15\x01\x16\x01\x99\x01\xb2\xfe\x09\x00\xdb\x02\x3a\x00\x3b\x00\x6e\x00\x6f\x00\x70\x00\x50\x00\xc7\x01\xab\x00\x51\x00\x09\x00\x52\x00\xc6\x01\x53\x00\xac\x00\x3e\x00\x54\x00\x55\x00\x56\x00\x57\x00\xc5\x01\x58\x00\x59\x00\x5a\x00\x5b\x00\x5c\x00\x5d\x00\x5e\x00\x5f\x00\x60\x00\x61\x00\x62\x00\x63\x00\x64\x00\x65\x00\x66\x00\x43\x02\x3c\x00\xa8\x00\xf9\x01\xfa\x01\x37\x02\x44\x02\x67\x00\x68\x00\x0a\x00\x37\x01\x3c\x02\x0c\x00\x0d\x00\x0e\x00\x0f\x00\x10\x00\x11\x00\x12\x00\x13\x00\x28\x00\x7e\x02\x3e\x00\x0c\x00\x0d\x00\x0e\x00\x0f\x00\x10\x00\x11\x00\x12\x00\x13\x00\x3d\x02\x3a\x02\x3e\x02\x3f\x02\x40\x02\x69\x00\x9a\x01\x09\x00\x6a\x00\x89\x00\x6b\x00\x76\x02\x6c\x00\x8a\x00\xb5\x00\x6d\x00\x31\x01\x91\x00\x97\x01\x2c\x00\x92\x00\x09\x00\xe1\x00\x92\x00\x2d\x00\x9b\x01\x43\x02\xab\x00\x6e\x00\x6f\x00\x70\x00\x50\x00\x44\x02\xac\x00\x51\x00\x8f\x01\x52\x00\x2e\x00\x53\x00\x2f\x00\x3e\x00\x54\x00\x55\x00\x56\x00\x57\x00\xec\x00\x58\x00\x59\x00\x5a\x00\x5b\x00\x5c\x00\x5d\x00\x5e\x00\x5f\x00\x60\x00\x61\x00\x62\x00\x63\x00\x64\x00\x65\x00\x66\x00\x15\x01\x16\x01\x37\x02\x3c\x01\x9c\x02\xd3\x02\x32\x01\x67\x00\x68\x00\x0c\x00\x0d\x00\x0e\x00\x0f\x00\x10\x00\x11\x00\x12\x00\x13\x00\x0e\x02\xf8\x02\xa5\x02\x43\x02\x88\x01\x43\x02\xd2\x02\xab\x00\x91\x00\x44\x02\xf3\x02\x44\x02\x3a\x02\xac\x00\x92\x00\x49\x00\x0f\x02\x49\x00\x0f\x02\x69\x00\x8b\x01\x43\x02\x6a\x00\x8a\x01\x6b\x00\x43\x02\x6c\x00\x44\x02\x85\x01\x6d\x00\x9d\x02\x44\x02\x11\x02\x3e\x00\xa6\x02\xa7\x02\x0b\x02\x12\x02\x98\x02\x12\x02\xfd\x02\x43\x02\x6e\x00\x6f\x00\x70\x00\x50\x00\x5b\x01\x44\x02\x51\x00\x9b\x02\x52\x00\x8b\x01\x53\x00\xe4\x00\x3e\x00\x54\x00\x55\x00\x56\x00\x57\x00\x59\x01\x58\x00\x59\x00\x5a\x00\x5b\x00\x5c\x00\x5d\x00\x5e\x00\x5f\x00\x60\x00\x61\x00\x62\x00\x63\x00\x64\x00\x65\x00\x66\x00\xd6\x01\xb5\x00\x15\x01\x16\x01\x8a\x00\x92\x01\x58\x01\x67\x00\x68\x00\x1f\x01\x29\x00\x93\x01\x83\x00\x19\x01\x2b\x00\x42\x00\x1e\x02\x2c\x00\x1f\x02\xb2\x02\xe4\x00\xe4\x00\x2d\x00\x19\x01\x43\x00\xb6\x00\xb7\x00\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x25\x01\x26\x01\xb8\x00\x2e\x00\x69\x00\x2f\x00\xf7\x00\x6a\x00\x4b\x00\x6b\x00\x4c\x00\x6c\x00\xd5\x02\xd6\x02\x6d\x00\xfe\x00\xff\x00\x00\x01\x01\x01\x02\x01\x50\x01\xe1\x00\x4d\x00\x4e\x00\x15\x01\x16\x01\x09\x01\x6e\x00\x6f\x00\x70\x00\x50\x00\x4b\x01\x92\x02\x51\x00\xe4\x00\x52\x00\x3a\x01\x53\x00\x5f\x02\x3e\x00\x54\x00\x55\x00\x56\x00\x57\x00\x5e\x02\x58\x00\x59\x00\x5a\x00\x5b\x00\x5c\x00\x5d\x00\x5e\x00\x5f\x00\x60\x00\x61\x00\x62\x00\x63\x00\x64\x00\x65\x00\x66\x00\xed\x00\x1b\x01\xe5\x01\xa8\x00\x2a\x01\x2c\x00\x57\x02\x67\x00\x68\x00\x56\x02\x2d\x00\x4d\x02\xcb\x01\x55\x02\x2c\x00\x42\x00\xcc\x01\xcd\x01\xce\x01\x2d\x00\x66\x02\x67\x02\xe4\x00\x2e\x00\x43\x00\x2f\x00\xdc\x00\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x2e\x00\x54\x02\x2f\x00\x53\x02\x69\x00\x05\x02\x4d\x02\x6a\x00\x4b\x00\x6b\x00\x4c\x00\x6c\x00\xed\x00\x1b\x01\x6d\x00\xed\x00\xee\x00\x3e\x00\x7a\x00\x7b\x00\x49\x02\x57\x00\x4d\x00\x4e\x00\xdd\x00\xe1\x00\xdf\x00\x6e\x00\x6f\x00\x70\x00\x50\x00\xa8\x00\xa9\x00\x51\x00\x46\x02\x52\x00\x48\x02\x53\x00\x37\x02\x3e\x00\x54\x00\x55\x00\x56\x00\x57\x00\x7c\x00\x58\x00\x59\x00\x5a\x00\x5b\x00\x5c\x00\x5d\x00\x5e\x00\x5f\x00\x60\x00\x61\x00\x62\x00\x63\x00\x64\x00\x65\x00\x66\x00\x98\x02\x99\x02\x9a\x02\x19\x01\xa8\x00\xf9\x01\xbb\x02\x67\x00\x68\x00\xed\x00\x1b\x01\x9b\x02\xed\x00\xa0\x01\x98\x00\x42\x00\x36\x02\x7e\x00\x32\x02\x7f\x00\x66\x02\xec\x02\xe4\x00\x2f\x02\x43\x00\x09\x01\xdc\x00\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x2a\x02\x72\x00\x73\x00\x74\x00\x69\x00\x9d\x00\x77\x00\x6a\x00\x4b\x00\x6b\x00\x4c\x00\x6c\x00\x42\x01\x26\x02\x6d\x00\x78\x00\x93\x01\x94\x01\x43\x01\x44\x01\x45\x01\xe1\x00\x4d\x00\x4e\x00\xdd\x00\xde\x00\xdf\x00\x6e\x00\x6f\x00\x70\x00\x50\x00\xa8\x00\x8d\x01\x51\x00\x25\x02\x52\x00\x23\x02\x53\x00\x09\x02\x3e\x00\x54\x00\x55\x00\x56\x00\x57\x00\x96\x01\x58\x00\x59\x00\x5a\x00\x5b\x00\x5c\x00\x5d\x00\x5e\x00\x5f\x00\x60\x00\x61\x00\x62\x00\x63\x00\x64\x00\x65\x00\x66\x00\x96\x00\x72\x00\x73\x00\x74\x00\x75\x00\x76\x00\x77\x00\x67\x00\x68\x00\x07\x02\x42\x00\xe6\x00\x8c\x01\xed\x00\x85\x01\x78\x00\x3f\x01\x88\x01\x42\x00\x43\x00\x06\x02\xdc\x00\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x43\x00\x50\x01\x51\x01\x3f\x01\x4c\x01\xf1\x00\x49\x00\x4a\x00\x4b\x00\x69\x00\x4c\x00\x3e\x00\x6a\x00\xf6\x01\x6b\x00\xf5\x01\x6c\x00\x3c\x01\x4b\x01\x6d\x00\x3f\x01\x49\x01\x4d\x00\x4e\x00\xdd\x00\x2f\x02\xdf\x00\x3c\x01\x48\x01\xf4\x01\x4d\x00\x4e\x00\x6e\x00\x6f\x00\x70\x00\x2d\xff\x2d\xff\x2d\xff\x2d\xff\x2d\xff\xf3\x01\x2d\xff\x2d\xff\x2d\xff\x2d\xff\x2d\xff\x2d\xff\x2d\xff\x2d\xff\x2d\xff\x2d\xff\x2d\xff\x2d\xff\x2d\xff\x2d\xff\x2d\xff\x89\x00\x2d\xff\x2d\xff\x2d\xff\x2d\xff\xb8\x02\x2d\xff\x2d\xff\xf1\x01\x2d\xff\x2d\xff\xea\x01\x2d\xff\x2d\xff\x2d\xff\x2d\xff\x2d\xff\x2d\xff\x2d\xff\x2d\xff\x2d\xff\x2d\xff\x2d\xff\x2d\xff\x2d\xff\x2d\xff\x2d\xff\x2d\xff\x2d\xff\x2d\xff\x2d\xff\x2d\xff\x2d\xff\x2d\xff\x2d\xff\x2d\xff\x2d\xff\x3e\x00\xb7\x02\x2d\xff\xb6\x02\x2d\xff\xb1\x02\x16\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x3f\x01\x40\x01\x2d\xff\xb0\x02\x1f\x00\x20\x00\x21\x00\x22\x00\xaf\x02\x24\x00\x2d\xff\x14\x02\x2d\xff\x2d\xff\xae\x02\x57\x00\xac\x02\x15\x02\x59\x00\x5a\x00\x5b\x00\x5c\x00\x5d\x00\x5e\x00\x5f\x00\x60\x00\x16\x02\x62\x00\x63\x00\x64\x00\xad\x02\x17\x02\x3c\x01\x3d\x01\x3f\x01\x58\x02\x3f\x01\x49\x02\xbc\x00\x9f\x02\xa5\x02\xbe\x00\xbf\x00\xa4\x02\xc0\x00\xc1\x00\xc2\x00\xc3\x00\xc4\x00\xc5\x00\xc6\x00\xc7\x00\xc8\x00\xc9\x00\xca\x00\xcb\x00\xcc\x00\xcd\x00\xce\x00\xcf\x00\xd0\x00\xd1\x00\xd2\x00\xd3\x00\xd4\x00\xd5\x00\xd6\x00\xd7\x00\x19\x02\xa0\x02\x96\x02\x1a\x02\x50\x01\x46\x02\x97\x02\x1b\x02\xba\xfe\x1c\x02\xed\x00\x30\x02\xed\x00\x02\x02\xd9\x00\x64\x02\xe0\x01\x72\x00\x73\x00\x74\x00\x75\x00\x76\x00\x77\x00\x84\x02\x6f\x00\x70\x00\x3e\x00\x54\x00\x55\x00\x56\x00\x57\x00\x78\x00\x58\x00\x59\x00\x5a\x00\x5b\x00\x5c\x00\x5d\x00\x5e\x00\x5f\x00\x60\x00\x61\x00\x62\x00\x63\x00\x64\x00\x65\x00\x66\x00\x1c\x02\x94\x01\x14\x02\xa8\x00\x97\x02\x7d\x02\x57\x00\x79\x02\x15\x02\x59\x00\x5a\x00\x5b\x00\x5c\x00\x5d\x00\x5e\x00\x5f\x00\x60\x00\x16\x02\x62\x00\x63\x00\x64\x00\x3e\x00\x17\x02\x8a\x02\x90\x02\x29\x00\x71\x02\x83\x00\x84\x00\x2b\x00\x18\x02\x42\x00\x2c\x00\x8a\x02\x8b\x02\x6d\x02\x69\x00\x2d\x00\x6e\x02\x6a\x00\x43\x00\x6b\x00\xdc\x00\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\xa8\x00\x7b\x02\x2e\x00\x64\x02\x2f\x00\x3c\x01\x76\x02\x66\x02\x4b\x00\x64\x02\x4c\x00\x19\x02\x6f\x00\x70\x00\x1a\x02\xed\x00\x1b\x01\xe6\x02\x1b\x02\xd7\x02\x1c\x02\x62\x02\x4d\x00\x4e\x00\xdd\x00\x07\x02\xdf\x00\x3f\x01\xdc\x02\x3f\x01\xda\x02\x3f\x01\xd8\x02\x14\x02\x61\x02\x6f\x00\x70\x00\x57\x00\x60\x02\x15\x02\x59\x00\x5a\x00\x5b\x00\x5c\x00\x5d\x00\x5e\x00\x5f\x00\x60\x00\x16\x02\x62\x00\x63\x00\x64\x00\xe4\x02\x17\x02\x3f\x01\xd7\x02\x15\x00\x8a\x02\xcc\x02\x3f\x01\xf7\x02\x18\x02\x16\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x20\x00\x21\x00\x22\x00\x23\x00\x24\x00\xf1\x01\x72\x00\x73\x00\x74\x00\x75\x00\x76\x00\x77\x00\x25\x00\x8a\x02\x05\x03\x42\x00\x3f\x01\x0d\x03\x19\x02\xe1\x02\x78\x00\x1a\x02\xe3\x02\x42\x00\x43\x00\xe2\x02\xe0\x02\x1c\x02\xdf\x02\xa0\x00\x49\x00\x4a\x00\x43\x00\x44\x00\x45\x00\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\xa5\x00\xd4\x02\x6f\x00\x70\x00\xd1\x02\xcf\x02\x26\x00\x34\x01\x4b\x00\xcc\x02\x4c\x00\xc9\x02\xc8\x02\xc7\x02\x4d\x00\x4e\x00\xc4\x02\xbd\x02\xf7\x02\xbb\x02\xf2\x02\xf1\x02\x4d\x00\x4e\x00\xf5\x02\x27\x00\x28\x00\xbc\x00\x3f\x01\xf4\x02\xbe\x00\xbf\x00\x07\x03\xc0\x00\xc1\x00\xc2\x00\xc3\x00\xc4\x00\xc5\x00\xc6\x00\xc7\x00\xc8\x00\xc9\x00\xca\x00\xcb\x00\xcc\x00\xcd\x00\xce\x00\xcf\x00\xd0\x00\xd1\x00\xd2\x00\xd3\x00\xd4\x00\xd5\x00\xd6\x00\xd7\x00\xa6\x00\x48\x01\x78\x02\xa7\x00\x1f\x01\x0a\x03\x6d\x02\xe6\x00\x04\x03\xa8\x00\x05\x03\xf7\x00\xf8\x00\xf1\x02\xd9\x00\x27\x01\x23\x01\x17\x01\xfc\x00\xfd\x00\xfe\x00\xff\x00\x00\x01\x01\x01\x02\x01\x87\x00\xd0\x01\xa1\x01\x9d\x01\xbc\x00\x3f\x01\x09\x01\xbe\x00\xbf\x00\x8f\x01\xc0\x00\xc1\x00\xc2\x00\xc3\x00\xc4\x00\xc5\x00\xc6\x00\xc7\x00\xc8\x00\xc9\x00\xca\x00\xcb\x00\xcc\x00\xcd\x00\xce\x00\xcf\x00\xd0\x00\xd1\x00\xd2\x00\xd3\x00\xd4\x00\xd5\x00\xd6\x00\xd7\x00\x61\x01\x59\x01\x38\x01\x44\x02\xf3\x00\xf4\x00\xf5\x00\xf6\x00\x5c\x02\xf7\x00\xf8\x00\x03\x02\xf9\x00\xfa\x00\xd9\x00\xfb\x00\xfc\x00\xfd\x00\xfe\x00\xff\x00\x00\x01\x01\x01\x02\x01\x03\x01\x04\x01\x05\x01\x06\x01\x07\x01\x08\x01\x09\x01\x0a\x01\x0b\x01\x0c\x01\x0d\x01\x0e\x01\x0f\x01\x10\x01\x11\x01\x12\x01\xea\x01\x72\x00\x73\x00\x74\x00\x75\x00\x76\x00\x77\x00\xb8\x02\xa0\x02\x94\x02\x79\x02\x89\x02\x6a\x02\xa0\x02\x13\x01\x78\x00\x69\x02\x9c\x01\xf3\x00\xf4\x00\xf5\x00\xf6\x00\x14\x01\xf7\x00\xf8\x00\x68\x02\xf9\x00\xfa\x00\x64\x02\xfb\x00\xfc\x00\xfd\x00\xfe\x00\xff\x00\x00\x01\x01\x01\x02\x01\x03\x01\x04\x01\x05\x01\x06\x01\x07\x01\x08\x01\x09\x01\x0a\x01\x0b\x01\x0c\x01\x0d\x01\x0e\x01\x0f\x01\x10\x01\x11\x01\x12\x01\x0a\x03\x72\x00\x73\x00\x74\x00\x75\x00\x76\x00\x77\x00\x62\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x13\x01\x78\x00\x00\x00\x0e\x02\xf3\x00\xf4\x00\xf5\x00\xf6\x00\x14\x01\xf7\x00\xf8\x00\x00\x00\xf9\x00\xfa\x00\x00\x00\xfb\x00\xfc\x00\xfd\x00\xfe\x00\xff\x00\x00\x01\x01\x01\x02\x01\x03\x01\x04\x01\x05\x01\x06\x01\x07\x01\x08\x01\x09\x01\x0a\x01\x0b\x01\x0c\x01\x0d\x01\x0e\x01\x0f\x01\x10\x01\x11\x01\x12\x01\x5d\x01\x00\x02\x5c\x01\x00\x00\x71\x00\x72\x00\x73\x00\x74\x00\x75\x00\x76\x00\x77\x00\x00\x00\x00\x00\x00\x00\x13\x01\xf3\x00\xf4\x00\xf5\x00\xf6\x00\x78\x00\xf7\x00\xf8\x00\x14\x01\xf9\x00\xfa\x00\x00\x00\xfb\x00\xfc\x00\xfd\x00\xfe\x00\xff\x00\x00\x01\x01\x01\x02\x01\x03\x01\x04\x01\x05\x01\x06\x01\x07\x01\x08\x01\x09\x01\x0a\x01\x0b\x01\x0c\x01\x0d\x01\x0e\x01\x0f\x01\x10\x01\x11\x01\x12\x01\x00\x00\x72\x00\x73\x00\x74\x00\x00\x00\x9a\x00\x77\x00\x9b\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x13\x01\x78\x00\x00\x00\xab\x02\xf3\x00\xf4\x00\xf5\x00\xf6\x00\x14\x01\xf7\x00\xf8\x00\x00\x00\xf9\x00\xfa\x00\x00\x00\xfb\x00\xfc\x00\xfd\x00\xfe\x00\xff\x00\x00\x01\x01\x01\x02\x01\x03\x01\x04\x01\x05\x01\x06\x01\x07\x01\x08\x01\x09\x01\x0a\x01\x0b\x01\x0c\x01\x0d\x01\x0e\x01\x0f\x01\x10\x01\x11\x01\x12\x01\x5b\x01\x00\x00\x5c\x01\x00\x00\x71\x00\x72\x00\x73\x00\x74\x00\x75\x00\x76\x00\x77\x00\x00\x00\x00\x00\x00\x00\x13\x01\xf3\x00\xf4\x00\xf5\x00\xf6\x00\x78\x00\xa3\x01\xa4\x01\x14\x01\xa5\x01\xa6\x01\x00\x00\xa7\x01\xa8\x01\xa9\x01\xaa\x01\xab\x01\xac\x01\xad\x01\xae\x01\xaf\x01\xb0\x01\xb1\x01\xb2\x01\xb3\x01\xb4\x01\xb5\x01\xb6\x01\xb7\x01\xb8\x01\xb9\x01\xba\x01\xbb\x01\xbc\x01\xbd\x01\xbe\x01\x23\x02\x00\x00\x5c\x01\x00\x00\x71\x00\x72\x00\x73\x00\x74\x00\x75\x00\x76\x00\x77\x00\x00\x00\x00\x00\x00\x00\xbf\x01\xf3\x00\xf4\x00\xf5\x00\xf6\x00\x78\x00\xf7\x00\xf8\x00\x14\x01\xf9\x00\xfa\x00\x00\x00\xfb\x00\xfc\x00\xfd\x00\xfe\x00\xff\x00\x00\x01\x01\x01\x02\x01\x03\x01\x04\x01\x05\x01\x06\x01\x07\x01\x08\x01\x09\x01\x0a\x01\x0b\x01\x0c\x01\x0d\x01\x0e\x01\x0f\x01\x10\x01\x11\x01\x12\x01\xb1\x02\x00\x00\x5c\x01\x00\x00\x71\x00\x72\x00\x73\x00\x74\x00\x75\x00\x76\x00\x77\x00\x00\x00\x00\x00\x00\x00\x13\x01\xf3\x00\x2c\x02\x2d\x02\x2e\x02\x78\x00\xf7\x00\xf8\x00\x14\x01\xf9\x00\xfa\x00\x00\x00\xfb\x00\xfc\x00\xfd\x00\xfe\x00\xff\x00\x00\x01\x01\x01\x02\x01\x03\x01\x04\x01\x05\x01\x06\x01\x07\x01\x08\x01\x09\x01\x0a\x01\x0b\x01\x0c\x01\x0d\x01\x0e\x01\x0f\x01\x10\x01\x11\x01\x12\x01\xe4\x02\x00\x00\x5c\x01\x00\x00\x71\x00\x72\x00\x73\x00\x74\x00\x75\x00\x76\x00\x77\x00\x00\x00\x00\x00\x00\x00\x13\x01\xf3\x00\xf4\x00\xf5\x00\xf6\x00\x78\x00\xf7\x00\xf8\x00\x14\x01\xf9\x00\xfa\x00\x00\x00\xfb\x00\xfc\x00\xfd\x00\xfe\x00\xff\x00\x00\x01\x01\x01\x02\x01\x03\x01\x04\x01\x05\x01\x06\x01\x07\x01\x08\x01\x09\x01\x0a\x01\x0b\x01\x0c\x01\x0d\x01\x0e\x01\x0f\x01\x10\x01\x11\x01\x12\x01\xc0\x02\x00\x00\x5c\x01\x00\x00\x71\x00\x72\x00\x73\x00\x74\x00\x75\x00\x76\x00\x77\x00\x00\x00\x00\x00\x00\x00\x13\x01\x00\x00\x00\x00\xf7\x00\xf8\x00\x78\x00\xf9\x00\xfa\x00\x14\x01\xfb\x00\xfc\x00\xfd\x00\xfe\x00\xff\x00\x00\x01\x01\x01\x02\x01\x03\x01\x04\x01\x05\x01\x06\x01\x07\x01\x08\x01\x09\x01\x0a\x01\x0b\x01\x0c\x01\x0d\x01\x0e\x01\x0f\x01\x10\x01\x11\x01\x12\x01\xfe\x02\x00\x00\x5c\x01\x00\x00\x71\x00\x72\x00\x73\x00\x74\x00\x75\x00\x76\x00\x77\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xbc\x00\x3f\x01\x78\x00\xbe\x00\xbf\x00\x14\x01\xc0\x00\xc1\x00\xc2\x00\xc3\x00\xc4\x00\xc5\x00\xc6\x00\xc7\x00\xc8\x00\xc9\x00\xca\x00\xcb\x00\xcc\x00\xcd\x00\xce\x00\xcf\x00\xd0\x00\xd1\x00\xd2\x00\xd3\x00\xd4\x00\xd5\x00\xd6\x00\xd7\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xb2\xfe\xb2\xfe\x00\x00\xb2\xfe\xb2\xfe\xd9\x00\xb2\xfe\xb2\xfe\xb2\xfe\xb2\xfe\xb2\xfe\xb2\xfe\xb2\xfe\xb2\xfe\xb2\xfe\xb2\xfe\xb2\xfe\xb2\xfe\xb2\xfe\xb2\xfe\xb2\xfe\xb2\xfe\xb2\xfe\xb2\xfe\xb2\xfe\xb2\xfe\xb2\xfe\xb2\xfe\xb2\xfe\xb2\xfe\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xbc\x00\x3f\x01\x00\x00\xbe\x00\xbf\x00\xb2\xfe\xc0\x00\xc1\x00\xc2\x00\xc3\x00\xc4\x00\xc5\x00\xc6\x00\xc7\x00\xc8\x00\xc9\x00\xca\x00\xcb\x00\xcc\x00\xcd\x00\xce\x00\xcf\x00\xd0\x00\xd1\x00\xd2\x00\xd3\x00\xd4\x00\xd5\x00\xd6\x00\xd7\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xb1\xfe\xb1\xfe\x00\x00\xb1\xfe\xb1\xfe\xd9\x00\xb1\xfe\xb1\xfe\xb1\xfe\xb1\xfe\xb1\xfe\xb1\xfe\xb1\xfe\xb1\xfe\xb1\xfe\xb1\xfe\xb1\xfe\xb1\xfe\xb1\xfe\xb1\xfe\xb1\xfe\xb1\xfe\xb1\xfe\xb1\xfe\xb1\xfe\xb1\xfe\xb1\xfe\xb1\xfe\xb1\xfe\xb1\xfe\x00\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x42\x00\x43\x00\xb1\xfe\xdc\x00\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x43\x00\x00\x00\xdc\x00\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x4b\x00\x00\x00\x4c\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4b\x00\x00\x00\x4c\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\xdd\x00\x01\x02\xdf\x00\x42\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\xdd\x00\x00\x00\x0b\x02\x00\x00\x43\x00\xac\x00\x45\x00\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\xad\x00\xae\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4b\x00\x00\x00\x4c\x00\x43\x00\xac\x00\x45\x00\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x00\x02\xae\x00\x42\x00\x4d\x00\x4e\x00\x00\x00\x00\x00\x00\x00\x4b\x00\x00\x00\x4c\x00\x43\x00\xec\x00\x45\x00\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x00\x00\x00\x00\x42\x00\x4d\x00\x4e\x00\x00\x00\x00\x00\x00\x00\x4b\x00\x00\x00\x4c\x00\x43\x00\xe2\x00\x45\x00\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x00\x00\x00\x00\x42\x00\x4d\x00\x4e\x00\x00\x00\x00\x00\x00\x00\x4b\x00\x00\x00\x4c\x00\x43\x00\xdb\x00\x45\x00\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x00\x00\x00\x00\x42\x00\x4d\x00\x4e\x00\x00\x00\x00\x00\x00\x00\x4b\x00\x00\x00\x4c\x00\x43\x00\x2a\x02\x45\x00\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x00\x00\x00\x00\x42\x00\x4d\x00\x4e\x00\x00\x00\x00\x00\x00\x00\x4b\x00\x00\x00\x4c\x00\x43\x00\x27\x02\x45\x00\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x00\x00\x00\x00\x42\x00\x4d\x00\x4e\x00\x00\x00\x00\x00\x00\x00\x4b\x00\x00\x00\x4c\x00\x43\x00\x26\x02\x45\x00\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x00\x00\x00\x00\x42\x00\x4d\x00\x4e\x00\x00\x00\x00\x00\x00\x00\x4b\x00\x00\x00\x4c\x00\x43\x00\x21\x02\x45\x00\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x00\x00\x00\x00\x42\x00\x4d\x00\x4e\x00\x00\x00\x00\x00\x00\x00\x4b\x00\x00\x00\x4c\x00\x43\x00\x1d\x02\x45\x00\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x00\x00\x00\x00\x42\x00\x4d\x00\x4e\x00\x00\x00\x00\x00\x00\x00\x4b\x00\x00\x00\x4c\x00\x43\x00\xfe\x01\x45\x00\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x00\x00\x00\x00\x42\x00\x4d\x00\x4e\x00\x00\x00\x00\x00\x00\x00\x4b\x00\x00\x00\x4c\x00\x43\x00\xfc\x01\x45\x00\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x00\x00\x00\x00\x42\x00\x4d\x00\x4e\x00\x00\x00\x00\x00\x00\x00\x4b\x00\x00\x00\x4c\x00\x43\x00\xf8\x01\x45\x00\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x00\x00\x00\x00\x42\x00\x4d\x00\x4e\x00\x00\x00\x00\x00\x00\x00\x4b\x00\x00\x00\x4c\x00\x43\x00\xb4\x02\x45\x00\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x00\x00\x00\x00\x42\x00\x4d\x00\x4e\x00\x00\x00\x00\x00\x00\x00\x4b\x00\x00\x00\x4c\x00\x43\x00\x93\x02\x45\x00\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x00\x00\x00\x00\x42\x00\x4d\x00\x4e\x00\x00\x00\x00\x00\x00\x00\x4b\x00\x00\x00\x4c\x00\x43\x00\x91\x02\x45\x00\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x00\x00\x00\x00\x42\x00\x4d\x00\x4e\x00\x00\x00\x00\x00\x00\x00\x4b\x00\x00\x00\x4c\x00\x43\x00\xcf\x02\x45\x00\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x00\x00\x00\x00\x42\x00\x4d\x00\x4e\x00\x00\x00\x00\x00\x00\x00\x4b\x00\x00\x00\x4c\x00\x43\x00\xcd\x02\x45\x00\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x00\x00\x00\x00\x42\x00\x4d\x00\x4e\x00\x00\x00\x00\x00\x00\x00\x4b\x00\x00\x00\x4c\x00\x43\x00\xca\x02\x45\x00\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x00\x00\x00\x00\x42\x00\x4d\x00\x4e\x00\x00\x00\x00\x00\x00\x00\x4b\x00\x00\x00\x4c\x00\x43\x00\xc9\x02\x45\x00\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x00\x00\x00\x00\x42\x00\x4d\x00\x4e\x00\x00\x00\x00\x00\x00\x00\x4b\x00\x00\x00\x4c\x00\x43\x00\xbf\x02\x45\x00\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x00\x00\x00\x00\x42\x00\x4d\x00\x4e\x00\x00\x00\x00\x00\x00\x00\x4b\x00\x00\x00\x4c\x00\x43\x00\xfb\x02\x45\x00\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x00\x00\x00\x00\x42\x00\x4d\x00\x4e\x00\x00\x00\x00\x00\x00\x00\x4b\x00\x00\x00\x4c\x00\x43\x00\xfa\x02\x45\x00\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x00\x00\x00\x00\x42\x00\x4d\x00\x4e\x00\x00\x00\x00\x00\x00\x00\x4b\x00\x00\x00\x4c\x00\x43\x00\xef\x02\x45\x00\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x00\x00\x00\x00\x42\x00\x4d\x00\x4e\x00\x00\x00\x00\x00\x00\x00\x4b\x00\x00\x00\x4c\x00\x43\x00\xee\x02\x45\x00\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x00\x00\x00\x00\x42\x00\x4d\x00\x4e\x00\x00\x00\x00\x00\x00\x00\x4b\x00\x00\x00\x4c\x00\x43\x00\xed\x02\x45\x00\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x00\x00\x00\x00\x42\x00\x4d\x00\x4e\x00\x00\x00\x00\x00\x00\x00\x4b\x00\x00\x00\x4c\x00\x43\x00\xeb\x02\x45\x00\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x00\x00\x00\x00\x42\x00\x4d\x00\x4e\x00\x00\x00\x00\x00\x00\x00\x4b\x00\x00\x00\x4c\x00\x43\x00\xea\x02\x45\x00\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x00\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\xda\x00\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\xd9\x00\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\xc2\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\xda\x00\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x97\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x83\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x81\x01\x46\x00\x47\x00\x82\x01\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x80\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x7f\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x7e\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x7d\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x7c\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x7b\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x7a\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x79\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x78\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x77\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x76\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x75\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x74\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x73\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x72\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x71\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x70\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x6f\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x6e\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x6d\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x6c\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x6b\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x6a\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x69\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x68\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x67\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x66\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x65\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x64\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x63\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x62\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x0c\x02\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x09\x02\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x7d\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x7c\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x7b\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x7a\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x79\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x78\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x77\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x76\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x75\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x74\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x73\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x72\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x71\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x70\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x6f\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x6e\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x6d\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x6c\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x6b\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x6a\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x69\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x68\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x67\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x66\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x65\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x64\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x63\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x62\x01\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\xa9\x02\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\xa8\x02\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x87\x02\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x86\x02\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x85\x02\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x84\x02\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x82\x02\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\xbd\x02\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x84\x02\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x00\x00\x00\x00\x0e\x02\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\xf9\x02\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x42\x00\x00\x00\x49\x00\x0f\x02\x00\x00\x4d\x00\x4e\x00\x00\x00\x4b\x00\x43\x00\x4c\x00\x0e\x02\x00\x00\x00\x00\xd3\x01\x49\x00\x4a\x00\x00\x03\x01\x03\x11\x02\x0e\x02\x00\x00\x4d\x00\x4e\x00\x12\x02\x00\x00\x49\x00\x0f\x02\x00\x00\x0e\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x49\x00\x0f\x02\x00\x00\x0e\x02\x4d\x00\x4e\x00\x00\x03\x0e\x03\x11\x02\x49\x00\x0f\x02\x00\x00\x00\x00\x12\x02\x00\x00\x10\x02\x00\x00\x11\x02\x49\x00\x0f\x02\x00\x00\x00\x00\x12\x02\x00\x00\xff\x02\x00\x00\x11\x02\x00\x00\x00\x00\x00\x00\x00\x00\x12\x02\x00\x00\xfc\x02\x00\x00\x11\x02\x00\x00\x00\x00\xf7\x00\xf8\x00\x12\x02\xf9\x00\xfa\x00\x00\x00\xfb\x00\xfc\x00\xfd\x00\xfe\x00\xff\x00\x00\x01\x01\x01\x02\x01\x03\x01\x04\x01\x05\x01\x06\x01\x07\x01\x08\x01\x09\x01\x0a\x01\x0b\x01\x0c\x01\x0d\x01\x0e\x01\x0f\x01\x10\x01\x11\x01\x12\x01\xf7\x00\xf8\x00\x00\x00\xf9\x00\xfa\x00\x00\x00\xfb\x00\xfc\x00\xfd\x00\xfe\x00\xff\x00\x00\x01\x01\x01\x02\x01\x03\x01\x04\x01\x05\x01\x06\x01\x07\x01\x08\x01\x09\x01\x0a\x01\x0b\x01\x00\x00\x0d\x01\x0e\x01\x0f\x01\x10\x01\x11\x01\x12\x01\xf7\x00\xf8\x00\x00\x00\xf9\x00\xfa\x00\x00\x00\xfb\x00\xfc\x00\xfd\x00\xfe\x00\xff\x00\x00\x01\x01\x01\x02\x01\x03\x01\x04\x01\x05\x01\x06\x01\x07\x01\x08\x01\x09\x01\x0a\x01\x0b\x01\x00\x00\x00\x00\x0e\x01\x0f\x01\x10\x01\x00\x00\x12\x01\xf7\x00\xf8\x00\x00\x00\xf9\x00\xfa\x00\x00\x00\xfb\x00\xfc\x00\xfd\x00\xfe\x00\xff\x00\x00\x01\x01\x01\x02\x01\x03\x01\x04\x01\x05\x01\x06\x01\x07\x01\x08\x01\x09\x01\x0a\x01\x0b\x01\x00\x00\x00\x00\x0e\x01\x0f\x01\x10\x01\xf7\x00\xf8\x00\x00\x00\x00\x00\xfa\x00\x00\x00\xfb\x00\xfc\x00\xfd\x00\xfe\x00\xff\x00\x00\x01\x01\x01\x02\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x09\x01\x0a\x01\x0b\x01\x00\x00\x00\x00\x0e\x01\x0f\x01\x10\x01\x29\x00\x00\x00\x83\x00\xe6\x01\x2b\x00\x00\x00\x29\x00\x2c\x00\x83\x00\xe4\x01\x2b\x00\x00\x00\x2d\x00\x2c\x00\x00\x00\x00\x00\x00\x00\x29\x00\x2d\x00\x83\x00\xe7\x01\x2b\x00\x00\x00\x00\x00\x2c\x00\x2e\x00\x00\x00\x2f\x00\x00\x00\x2d\x00\x00\x00\x2e\x00\x00\x00\x2f\x00\x80\x00\x81\x00\x00\x00\x00\x00\x82\x00\x00\x00\x00\x00\x2c\x00\x2e\x00\x29\x00\x2f\x00\x2a\x00\x2d\x00\x2b\x00\x00\x00\x00\x00\x2c\x00\x00\x00\x00\x00\x00\x00\x00\x00\x2d\x00\x00\x00\x00\x00\x00\x00\x2e\x00\x29\x00\x2f\x00\x1f\x01\x00\x00\x2b\x00\x00\x00\x00\x00\x2c\x00\x2e\x00\x85\x00\x2f\x00\x00\x00\x2d\x00\x86\x00\x00\x00\x00\x00\x2c\x00\x00\x00\x00\x00\x00\x00\x00\x00\x2d\x00\x00\x00\x00\x00\x00\x00\x2e\x00\x00\x00\x2f\x00\x00\x00\x00\x00\xf7\x00\xf8\x00\x00\x00\x00\x00\x2e\x00\x00\x00\x2f\x00\xfc\x00\xfd\x00\xfe\x00\xff\x00\x00\x01\x01\x01\x02\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x09\x01\x0a\x01\x0b\x01\x08\x03\x00\x00\x5c\x01\x00\x00\x71\x00\x72\x00\x73\x00\x74\x00\x75\x00\x76\x00\x77\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x07\x03\x00\x00\x5c\x01\x78\x00\x71\x00\x72\x00\x73\x00\x74\x00\x75\x00\x76\x00\x77\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xed\x01\x78\x00\x71\x00\x72\x00\x73\x00\x74\x00\x75\x00\x76\x00\x77\x00\x00\x00\x00\x00\x00\x00\xee\x01\x00\x00\x00\x00\x00\x00\xed\x01\x78\x00\x71\x00\x72\x00\x73\x00\x74\x00\x75\x00\x76\x00\x77\x00\x00\x00\x00\x00\x00\x00\xb9\x02\x00\x00\x00\x00\x00\x00\x70\x00\x78\x00\x71\x00\x72\x00\x73\x00\x74\x00\x75\x00\x76\x00\x77\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x93\x00\x78\x00\x71\x00\x72\x00\x73\x00\x74\x00\x75\x00\x76\x00\x77\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xd4\x01\x78\x00\x71\x00\x72\x00\x73\x00\x74\x00\x75\x00\x76\x00\x77\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xef\x01\x78\x00\x71\x00\x72\x00\x73\x00\x74\x00\x75\x00\x76\x00\x77\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xec\x01\x78\x00\x71\x00\x72\x00\x73\x00\x74\x00\x75\x00\x76\x00\x77\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xe8\x01\x78\x00\x71\x00\x72\x00\x73\x00\x74\x00\x75\x00\x76\x00\x77\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xdd\x02\x78\x00\x71\x00\x72\x00\x73\x00\x74\x00\x75\x00\x76\x00\x77\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x03\x78\x00\x71\x00\x72\x00\x73\x00\x74\x00\x75\x00\x76\x00\x77\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x0b\x03\x78\x00\x71\x00\x72\x00\x73\x00\x74\x00\x75\x00\x76\x00\x77\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x78\x00\xa2\x02\x59\x00\x5a\x00\x5b\x00\x5c\x00\x5d\x00\x5e\x00\x5f\x00\x60\x00\xa3\x02\x62\x00\x63\x00\x64\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"#

happyReduceArr = Happy_Data_Array.array (7, 402) [
	(7 , happyReduce_7),
	(8 , happyReduce_8),
	(9 , happyReduce_9),
	(10 , happyReduce_10),
	(11 , happyReduce_11),
	(12 , happyReduce_12),
	(13 , happyReduce_13),
	(14 , happyReduce_14),
	(15 , happyReduce_15),
	(16 , happyReduce_16),
	(17 , happyReduce_17),
	(18 , happyReduce_18),
	(19 , happyReduce_19),
	(20 , happyReduce_20),
	(21 , happyReduce_21),
	(22 , happyReduce_22),
	(23 , happyReduce_23),
	(24 , happyReduce_24),
	(25 , happyReduce_25),
	(26 , happyReduce_26),
	(27 , happyReduce_27),
	(28 , happyReduce_28),
	(29 , happyReduce_29),
	(30 , happyReduce_30),
	(31 , happyReduce_31),
	(32 , happyReduce_32),
	(33 , happyReduce_33),
	(34 , happyReduce_34),
	(35 , happyReduce_35),
	(36 , happyReduce_36),
	(37 , happyReduce_37),
	(38 , happyReduce_38),
	(39 , happyReduce_39),
	(40 , happyReduce_40),
	(41 , happyReduce_41),
	(42 , happyReduce_42),
	(43 , happyReduce_43),
	(44 , happyReduce_44),
	(45 , happyReduce_45),
	(46 , happyReduce_46),
	(47 , happyReduce_47),
	(48 , happyReduce_48),
	(49 , happyReduce_49),
	(50 , happyReduce_50),
	(51 , happyReduce_51),
	(52 , happyReduce_52),
	(53 , happyReduce_53),
	(54 , happyReduce_54),
	(55 , happyReduce_55),
	(56 , happyReduce_56),
	(57 , happyReduce_57),
	(58 , happyReduce_58),
	(59 , happyReduce_59),
	(60 , happyReduce_60),
	(61 , happyReduce_61),
	(62 , happyReduce_62),
	(63 , happyReduce_63),
	(64 , happyReduce_64),
	(65 , happyReduce_65),
	(66 , happyReduce_66),
	(67 , happyReduce_67),
	(68 , happyReduce_68),
	(69 , happyReduce_69),
	(70 , happyReduce_70),
	(71 , happyReduce_71),
	(72 , happyReduce_72),
	(73 , happyReduce_73),
	(74 , happyReduce_74),
	(75 , happyReduce_75),
	(76 , happyReduce_76),
	(77 , happyReduce_77),
	(78 , happyReduce_78),
	(79 , happyReduce_79),
	(80 , happyReduce_80),
	(81 , happyReduce_81),
	(82 , happyReduce_82),
	(83 , happyReduce_83),
	(84 , happyReduce_84),
	(85 , happyReduce_85),
	(86 , happyReduce_86),
	(87 , happyReduce_87),
	(88 , happyReduce_88),
	(89 , happyReduce_89),
	(90 , happyReduce_90),
	(91 , happyReduce_91),
	(92 , happyReduce_92),
	(93 , happyReduce_93),
	(94 , happyReduce_94),
	(95 , happyReduce_95),
	(96 , happyReduce_96),
	(97 , happyReduce_97),
	(98 , happyReduce_98),
	(99 , happyReduce_99),
	(100 , happyReduce_100),
	(101 , happyReduce_101),
	(102 , happyReduce_102),
	(103 , happyReduce_103),
	(104 , happyReduce_104),
	(105 , happyReduce_105),
	(106 , happyReduce_106),
	(107 , happyReduce_107),
	(108 , happyReduce_108),
	(109 , happyReduce_109),
	(110 , happyReduce_110),
	(111 , happyReduce_111),
	(112 , happyReduce_112),
	(113 , happyReduce_113),
	(114 , happyReduce_114),
	(115 , happyReduce_115),
	(116 , happyReduce_116),
	(117 , happyReduce_117),
	(118 , happyReduce_118),
	(119 , happyReduce_119),
	(120 , happyReduce_120),
	(121 , happyReduce_121),
	(122 , happyReduce_122),
	(123 , happyReduce_123),
	(124 , happyReduce_124),
	(125 , happyReduce_125),
	(126 , happyReduce_126),
	(127 , happyReduce_127),
	(128 , happyReduce_128),
	(129 , happyReduce_129),
	(130 , happyReduce_130),
	(131 , happyReduce_131),
	(132 , happyReduce_132),
	(133 , happyReduce_133),
	(134 , happyReduce_134),
	(135 , happyReduce_135),
	(136 , happyReduce_136),
	(137 , happyReduce_137),
	(138 , happyReduce_138),
	(139 , happyReduce_139),
	(140 , happyReduce_140),
	(141 , happyReduce_141),
	(142 , happyReduce_142),
	(143 , happyReduce_143),
	(144 , happyReduce_144),
	(145 , happyReduce_145),
	(146 , happyReduce_146),
	(147 , happyReduce_147),
	(148 , happyReduce_148),
	(149 , happyReduce_149),
	(150 , happyReduce_150),
	(151 , happyReduce_151),
	(152 , happyReduce_152),
	(153 , happyReduce_153),
	(154 , happyReduce_154),
	(155 , happyReduce_155),
	(156 , happyReduce_156),
	(157 , happyReduce_157),
	(158 , happyReduce_158),
	(159 , happyReduce_159),
	(160 , happyReduce_160),
	(161 , happyReduce_161),
	(162 , happyReduce_162),
	(163 , happyReduce_163),
	(164 , happyReduce_164),
	(165 , happyReduce_165),
	(166 , happyReduce_166),
	(167 , happyReduce_167),
	(168 , happyReduce_168),
	(169 , happyReduce_169),
	(170 , happyReduce_170),
	(171 , happyReduce_171),
	(172 , happyReduce_172),
	(173 , happyReduce_173),
	(174 , happyReduce_174),
	(175 , happyReduce_175),
	(176 , happyReduce_176),
	(177 , happyReduce_177),
	(178 , happyReduce_178),
	(179 , happyReduce_179),
	(180 , happyReduce_180),
	(181 , happyReduce_181),
	(182 , happyReduce_182),
	(183 , happyReduce_183),
	(184 , happyReduce_184),
	(185 , happyReduce_185),
	(186 , happyReduce_186),
	(187 , happyReduce_187),
	(188 , happyReduce_188),
	(189 , happyReduce_189),
	(190 , happyReduce_190),
	(191 , happyReduce_191),
	(192 , happyReduce_192),
	(193 , happyReduce_193),
	(194 , happyReduce_194),
	(195 , happyReduce_195),
	(196 , happyReduce_196),
	(197 , happyReduce_197),
	(198 , happyReduce_198),
	(199 , happyReduce_199),
	(200 , happyReduce_200),
	(201 , happyReduce_201),
	(202 , happyReduce_202),
	(203 , happyReduce_203),
	(204 , happyReduce_204),
	(205 , happyReduce_205),
	(206 , happyReduce_206),
	(207 , happyReduce_207),
	(208 , happyReduce_208),
	(209 , happyReduce_209),
	(210 , happyReduce_210),
	(211 , happyReduce_211),
	(212 , happyReduce_212),
	(213 , happyReduce_213),
	(214 , happyReduce_214),
	(215 , happyReduce_215),
	(216 , happyReduce_216),
	(217 , happyReduce_217),
	(218 , happyReduce_218),
	(219 , happyReduce_219),
	(220 , happyReduce_220),
	(221 , happyReduce_221),
	(222 , happyReduce_222),
	(223 , happyReduce_223),
	(224 , happyReduce_224),
	(225 , happyReduce_225),
	(226 , happyReduce_226),
	(227 , happyReduce_227),
	(228 , happyReduce_228),
	(229 , happyReduce_229),
	(230 , happyReduce_230),
	(231 , happyReduce_231),
	(232 , happyReduce_232),
	(233 , happyReduce_233),
	(234 , happyReduce_234),
	(235 , happyReduce_235),
	(236 , happyReduce_236),
	(237 , happyReduce_237),
	(238 , happyReduce_238),
	(239 , happyReduce_239),
	(240 , happyReduce_240),
	(241 , happyReduce_241),
	(242 , happyReduce_242),
	(243 , happyReduce_243),
	(244 , happyReduce_244),
	(245 , happyReduce_245),
	(246 , happyReduce_246),
	(247 , happyReduce_247),
	(248 , happyReduce_248),
	(249 , happyReduce_249),
	(250 , happyReduce_250),
	(251 , happyReduce_251),
	(252 , happyReduce_252),
	(253 , happyReduce_253),
	(254 , happyReduce_254),
	(255 , happyReduce_255),
	(256 , happyReduce_256),
	(257 , happyReduce_257),
	(258 , happyReduce_258),
	(259 , happyReduce_259),
	(260 , happyReduce_260),
	(261 , happyReduce_261),
	(262 , happyReduce_262),
	(263 , happyReduce_263),
	(264 , happyReduce_264),
	(265 , happyReduce_265),
	(266 , happyReduce_266),
	(267 , happyReduce_267),
	(268 , happyReduce_268),
	(269 , happyReduce_269),
	(270 , happyReduce_270),
	(271 , happyReduce_271),
	(272 , happyReduce_272),
	(273 , happyReduce_273),
	(274 , happyReduce_274),
	(275 , happyReduce_275),
	(276 , happyReduce_276),
	(277 , happyReduce_277),
	(278 , happyReduce_278),
	(279 , happyReduce_279),
	(280 , happyReduce_280),
	(281 , happyReduce_281),
	(282 , happyReduce_282),
	(283 , happyReduce_283),
	(284 , happyReduce_284),
	(285 , happyReduce_285),
	(286 , happyReduce_286),
	(287 , happyReduce_287),
	(288 , happyReduce_288),
	(289 , happyReduce_289),
	(290 , happyReduce_290),
	(291 , happyReduce_291),
	(292 , happyReduce_292),
	(293 , happyReduce_293),
	(294 , happyReduce_294),
	(295 , happyReduce_295),
	(296 , happyReduce_296),
	(297 , happyReduce_297),
	(298 , happyReduce_298),
	(299 , happyReduce_299),
	(300 , happyReduce_300),
	(301 , happyReduce_301),
	(302 , happyReduce_302),
	(303 , happyReduce_303),
	(304 , happyReduce_304),
	(305 , happyReduce_305),
	(306 , happyReduce_306),
	(307 , happyReduce_307),
	(308 , happyReduce_308),
	(309 , happyReduce_309),
	(310 , happyReduce_310),
	(311 , happyReduce_311),
	(312 , happyReduce_312),
	(313 , happyReduce_313),
	(314 , happyReduce_314),
	(315 , happyReduce_315),
	(316 , happyReduce_316),
	(317 , happyReduce_317),
	(318 , happyReduce_318),
	(319 , happyReduce_319),
	(320 , happyReduce_320),
	(321 , happyReduce_321),
	(322 , happyReduce_322),
	(323 , happyReduce_323),
	(324 , happyReduce_324),
	(325 , happyReduce_325),
	(326 , happyReduce_326),
	(327 , happyReduce_327),
	(328 , happyReduce_328),
	(329 , happyReduce_329),
	(330 , happyReduce_330),
	(331 , happyReduce_331),
	(332 , happyReduce_332),
	(333 , happyReduce_333),
	(334 , happyReduce_334),
	(335 , happyReduce_335),
	(336 , happyReduce_336),
	(337 , happyReduce_337),
	(338 , happyReduce_338),
	(339 , happyReduce_339),
	(340 , happyReduce_340),
	(341 , happyReduce_341),
	(342 , happyReduce_342),
	(343 , happyReduce_343),
	(344 , happyReduce_344),
	(345 , happyReduce_345),
	(346 , happyReduce_346),
	(347 , happyReduce_347),
	(348 , happyReduce_348),
	(349 , happyReduce_349),
	(350 , happyReduce_350),
	(351 , happyReduce_351),
	(352 , happyReduce_352),
	(353 , happyReduce_353),
	(354 , happyReduce_354),
	(355 , happyReduce_355),
	(356 , happyReduce_356),
	(357 , happyReduce_357),
	(358 , happyReduce_358),
	(359 , happyReduce_359),
	(360 , happyReduce_360),
	(361 , happyReduce_361),
	(362 , happyReduce_362),
	(363 , happyReduce_363),
	(364 , happyReduce_364),
	(365 , happyReduce_365),
	(366 , happyReduce_366),
	(367 , happyReduce_367),
	(368 , happyReduce_368),
	(369 , happyReduce_369),
	(370 , happyReduce_370),
	(371 , happyReduce_371),
	(372 , happyReduce_372),
	(373 , happyReduce_373),
	(374 , happyReduce_374),
	(375 , happyReduce_375),
	(376 , happyReduce_376),
	(377 , happyReduce_377),
	(378 , happyReduce_378),
	(379 , happyReduce_379),
	(380 , happyReduce_380),
	(381 , happyReduce_381),
	(382 , happyReduce_382),
	(383 , happyReduce_383),
	(384 , happyReduce_384),
	(385 , happyReduce_385),
	(386 , happyReduce_386),
	(387 , happyReduce_387),
	(388 , happyReduce_388),
	(389 , happyReduce_389),
	(390 , happyReduce_390),
	(391 , happyReduce_391),
	(392 , happyReduce_392),
	(393 , happyReduce_393),
	(394 , happyReduce_394),
	(395 , happyReduce_395),
	(396 , happyReduce_396),
	(397 , happyReduce_397),
	(398 , happyReduce_398),
	(399 , happyReduce_399),
	(400 , happyReduce_400),
	(401 , happyReduce_401),
	(402 , happyReduce_402)
	]

happy_n_terms = 103 :: Prelude.Int
happy_n_nonterms = 109 :: Prelude.Int

#if __GLASGOW_HASKELL__ >= 710
happyReduce_7 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_7 = happySpecReduce_1  0# happyReduction_7
happyReduction_7 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn10
		 (let L loc (DOC s) = happy_var_1 in DocComment s loc
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_8 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_8 = happyReduce 4# 1# happyReduction_8
happyReduction_8 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut10 happy_x_1 of { (HappyWrap10 happy_var_1) -> 
	case happyOut10 happy_x_2 of { (HappyWrap10 happy_var_2) -> 
	case happyOut14 happy_x_3 of { (HappyWrap14 happy_var_3) -> 
	case happyOut13 happy_x_4 of { (HappyWrap13 happy_var_4) -> 
	happyIn11
		 (Prog (Just happy_var_1) (addDoc happy_var_2 happy_var_3 : happy_var_4)
	) `HappyStk` happyRest}}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_9 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_9 = happySpecReduce_3  1# happyReduction_9
happyReduction_9 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut10 happy_x_1 of { (HappyWrap10 happy_var_1) -> 
	case happyOut14 happy_x_2 of { (HappyWrap14 happy_var_2) -> 
	case happyOut13 happy_x_3 of { (HappyWrap13 happy_var_3) -> 
	happyIn11
		 (Prog (Just happy_var_1) (happy_var_2 : happy_var_3)
	)}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_10 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_10 = happySpecReduce_2  1# happyReduction_10
happyReduction_10 happy_x_2
	happy_x_1
	 =  case happyOut14 happy_x_1 of { (HappyWrap14 happy_var_1) -> 
	case happyOut13 happy_x_2 of { (HappyWrap13 happy_var_2) -> 
	happyIn11
		 (Prog Nothing (happy_var_1 : happy_var_2)
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_11 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_11 = happySpecReduce_0  1# happyReduction_11
happyReduction_11  =  happyIn11
		 (Prog Nothing []
	)

#if __GLASGOW_HASKELL__ >= 710
happyReduce_12 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_12 = happySpecReduce_1  2# happyReduction_12
happyReduction_12 happy_x_1
	 =  case happyOut14 happy_x_1 of { (HappyWrap14 happy_var_1) -> 
	happyIn12
		 (happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_13 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_13 = happySpecReduce_2  2# happyReduction_13
happyReduction_13 happy_x_2
	happy_x_1
	 =  case happyOut10 happy_x_1 of { (HappyWrap10 happy_var_1) -> 
	case happyOut14 happy_x_2 of { (HappyWrap14 happy_var_2) -> 
	happyIn12
		 (addDoc happy_var_1 happy_var_2
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_14 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_14 = happySpecReduce_0  3# happyReduction_14
happyReduction_14  =  happyIn13
		 ([]
	)

#if __GLASGOW_HASKELL__ >= 710
happyReduce_15 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_15 = happySpecReduce_2  3# happyReduction_15
happyReduction_15 happy_x_2
	happy_x_1
	 =  case happyOut12 happy_x_1 of { (HappyWrap12 happy_var_1) -> 
	case happyOut13 happy_x_2 of { (HappyWrap13 happy_var_2) -> 
	happyIn13
		 (happy_var_1 : happy_var_2
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_16 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_16 = happySpecReduce_1  4# happyReduction_16
happyReduction_16 happy_x_1
	 =  case happyOut35 happy_x_1 of { (HappyWrap35 happy_var_1) -> 
	happyIn14
		 (ValDec happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_17 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_17 = happySpecReduce_1  4# happyReduction_17
happyReduction_17 happy_x_1
	 =  case happyOut37 happy_x_1 of { (HappyWrap37 happy_var_1) -> 
	happyIn14
		 (TypeDec happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_18 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_18 = happySpecReduce_1  4# happyReduction_18
happyReduction_18 happy_x_1
	 =  case happyOut17 happy_x_1 of { (HappyWrap17 happy_var_1) -> 
	happyIn14
		 (SigDec happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_19 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_19 = happySpecReduce_1  4# happyReduction_19
happyReduction_19 happy_x_1
	 =  case happyOut22 happy_x_1 of { (HappyWrap22 happy_var_1) -> 
	happyIn14
		 (ModDec happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_20 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_20 = happySpecReduce_2  4# happyReduction_20
happyReduction_20 happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { (L happy_var_1 OPEN) -> 
	case happyOut18 happy_x_2 of { (HappyWrap18 happy_var_2) -> 
	happyIn14
		 (OpenDec happy_var_2 happy_var_1
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_21 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_21 = happySpecReduce_2  4# happyReduction_21
happyReduction_21 happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { (L happy_var_1 IMPORT) -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	happyIn14
		 (let L _ (STRINGLIT s) = happy_var_2 in ImportDec (T.unpack s) NoInfo (srcspan happy_var_1 happy_var_2)
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_22 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_22 = happySpecReduce_2  4# happyReduction_22
happyReduction_22 happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { (L happy_var_1 LOCAL) -> 
	case happyOut12 happy_x_2 of { (HappyWrap12 happy_var_2) -> 
	happyIn14
		 (LocalDec happy_var_2 (srcspan happy_var_1 happy_var_2)
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_23 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_23 = happyReduce 4# 4# happyReduction_23
happyReduction_23 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut99 happy_x_2 of { (HappyWrap99 happy_var_2) -> 
	case happyOut14 happy_x_4 of { (HappyWrap14 happy_var_4) -> 
	happyIn14
		 (addAttr happy_var_2 happy_var_4
	) `HappyStk` happyRest}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_24 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_24 = happySpecReduce_1  5# happyReduction_24
happyReduction_24 happy_x_1
	 =  case happyOut55 happy_x_1 of { (HappyWrap55 happy_var_1) -> 
	happyIn15
		 (let (v, loc) = happy_var_1 in SigVar v NoInfo loc
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_25 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_25 = happySpecReduce_3  5# happyReduction_25
happyReduction_25 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { (L happy_var_1 LCURLY) -> 
	case happyOut27 happy_x_2 of { (HappyWrap27 happy_var_2) -> 
	case happyOutTok happy_x_3 of { (L happy_var_3 RCURLY) -> 
	happyIn15
		 (SigSpecs happy_var_2 (srcspan happy_var_1 happy_var_3)
	)}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_26 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_26 = happySpecReduce_3  5# happyReduction_26
happyReduction_26 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut15 happy_x_1 of { (HappyWrap15 happy_var_1) -> 
	case happyOut16 happy_x_3 of { (HappyWrap16 happy_var_3) -> 
	happyIn15
		 (SigWith happy_var_1 happy_var_3 (srcspan happy_var_1 happy_var_3)
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_27 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_27 = happySpecReduce_3  5# happyReduction_27
happyReduction_27 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { (L happy_var_1 LPAR) -> 
	case happyOut15 happy_x_2 of { (HappyWrap15 happy_var_2) -> 
	case happyOutTok happy_x_3 of { (L happy_var_3 RPAR) -> 
	happyIn15
		 (SigParens happy_var_2 (srcspan happy_var_1 happy_var_3)
	)}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_28 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_28 = happyReduce 7# 5# happyReduction_28
happyReduction_28 (happy_x_7 `HappyStk`
	happy_x_6 `HappyStk`
	happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { (L happy_var_1 LPAR) -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut15 happy_x_4 of { (HappyWrap15 happy_var_4) -> 
	case happyOut15 happy_x_7 of { (HappyWrap15 happy_var_7) -> 
	happyIn15
		 (let L _ (ID name) = happy_var_2
                                in SigArrow (Just name) happy_var_4 happy_var_7 (srcspan happy_var_1 happy_var_7)
	) `HappyStk` happyRest}}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_29 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_29 = happySpecReduce_3  5# happyReduction_29
happyReduction_29 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut15 happy_x_1 of { (HappyWrap15 happy_var_1) -> 
	case happyOut15 happy_x_3 of { (HappyWrap15 happy_var_3) -> 
	happyIn15
		 (SigArrow Nothing happy_var_1 happy_var_3 (srcspan happy_var_1 happy_var_3)
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_30 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_30 = happyReduce 4# 6# happyReduction_30
happyReduction_30 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut55 happy_x_1 of { (HappyWrap55 happy_var_1) -> 
	case happyOut31 happy_x_2 of { (HappyWrap31 happy_var_2) -> 
	case happyOut40 happy_x_4 of { (HappyWrap40 happy_var_4) -> 
	happyIn16
		 (TypeRef (fst happy_var_1) happy_var_2 (TypeDecl happy_var_4 NoInfo) (srcspan (snd happy_var_1) happy_var_4)
	) `HappyStk` happyRest}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_31 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_31 = happyReduce 5# 7# happyReduction_31
happyReduction_31 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { (L happy_var_1 MODULE) -> 
	case happyOutTok happy_x_3 of { happy_var_3 -> 
	case happyOut15 happy_x_5 of { (HappyWrap15 happy_var_5) -> 
	happyIn17
		 (let L _ (ID name) = happy_var_3
            in SigBind name happy_var_5 Nothing (srcspan happy_var_1 happy_var_5)
	) `HappyStk` happyRest}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_32 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_32 = happySpecReduce_3  8# happyReduction_32
happyReduction_32 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut18 happy_x_1 of { (HappyWrap18 happy_var_1) -> 
	case happyOut15 happy_x_3 of { (HappyWrap15 happy_var_3) -> 
	happyIn18
		 (ModAscript happy_var_1 happy_var_3 NoInfo (srcspan happy_var_1 happy_var_3)
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_33 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_33 = happyReduce 5# 8# happyReduction_33
happyReduction_33 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { (L happy_var_1 BACKSLASH) -> 
	case happyOut23 happy_x_2 of { (HappyWrap23 happy_var_2) -> 
	case happyOut116 happy_x_3 of { happy_var_3 -> 
	case happyOut18 happy_x_5 of { (HappyWrap18 happy_var_5) -> 
	happyIn18
		 (ModLambda happy_var_2 (fmap (,NoInfo) happy_var_3) happy_var_5 (srcspan happy_var_1 happy_var_5)
	) `HappyStk` happyRest}}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_34 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_34 = happySpecReduce_2  8# happyReduction_34
happyReduction_34 happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { (L happy_var_1 IMPORT) -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	happyIn18
		 (let L _ (STRINGLIT s) = happy_var_2 in ModImport (T.unpack s) NoInfo (srcspan happy_var_1 happy_var_2)
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_35 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_35 = happySpecReduce_1  8# happyReduction_35
happyReduction_35 happy_x_1
	 =  case happyOut19 happy_x_1 of { (HappyWrap19 happy_var_1) -> 
	happyIn18
		 (happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_36 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_36 = happySpecReduce_1  8# happyReduction_36
happyReduction_36 happy_x_1
	 =  case happyOut20 happy_x_1 of { (HappyWrap20 happy_var_1) -> 
	happyIn18
		 (happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_37 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_37 = happySpecReduce_2  9# happyReduction_37
happyReduction_37 happy_x_2
	happy_x_1
	 =  case happyOut20 happy_x_1 of { (HappyWrap20 happy_var_1) -> 
	case happyOut20 happy_x_2 of { (HappyWrap20 happy_var_2) -> 
	happyIn19
		 (ModApply happy_var_1 happy_var_2 NoInfo NoInfo (srcspan happy_var_1 happy_var_2)
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_38 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_38 = happySpecReduce_2  9# happyReduction_38
happyReduction_38 happy_x_2
	happy_x_1
	 =  case happyOut19 happy_x_1 of { (HappyWrap19 happy_var_1) -> 
	case happyOut20 happy_x_2 of { (HappyWrap20 happy_var_2) -> 
	happyIn19
		 (ModApply happy_var_1 happy_var_2 NoInfo NoInfo (srcspan happy_var_1 happy_var_2)
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_39 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_39 = happySpecReduce_3  10# happyReduction_39
happyReduction_39 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { (L happy_var_1 LPAR) -> 
	case happyOut18 happy_x_2 of { (HappyWrap18 happy_var_2) -> 
	case happyOutTok happy_x_3 of { (L happy_var_3 RPAR) -> 
	happyIn20
		 (ModParens happy_var_2 (srcspan happy_var_1 happy_var_3)
	)}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_40 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_40 = happySpecReduce_1  10# happyReduction_40
happyReduction_40 happy_x_1
	 =  case happyOut55 happy_x_1 of { (HappyWrap55 happy_var_1) -> 
	happyIn20
		 (let (v, loc) = happy_var_1 in ModVar v loc
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_41 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_41 = happySpecReduce_3  10# happyReduction_41
happyReduction_41 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { (L happy_var_1 LCURLY) -> 
	case happyOut13 happy_x_2 of { (HappyWrap13 happy_var_2) -> 
	case happyOutTok happy_x_3 of { (L happy_var_3 RCURLY) -> 
	happyIn20
		 (ModDecs happy_var_2 (srcspan happy_var_1 happy_var_3)
	)}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_42 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_42 = happySpecReduce_1  11# happyReduction_42
happyReduction_42 happy_x_1
	 =  case happyOut55 happy_x_1 of { (HappyWrap55 happy_var_1) -> 
	happyIn21
		 (let (v, loc) = happy_var_1 in SigVar v NoInfo loc
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_43 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_43 = happySpecReduce_3  11# happyReduction_43
happyReduction_43 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut15 happy_x_2 of { (HappyWrap15 happy_var_2) -> 
	happyIn21
		 (happy_var_2
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_44 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_44 = happyReduce 6# 12# happyReduction_44
happyReduction_44 (happy_x_6 `HappyStk`
	happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { (L happy_var_1 MODULE) -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut24 happy_x_3 of { (HappyWrap24 happy_var_3) -> 
	case happyOut115 happy_x_4 of { happy_var_4 -> 
	case happyOut18 happy_x_6 of { (HappyWrap18 happy_var_6) -> 
	happyIn22
		 (let L floc (ID fname) = happy_var_2;
             in ModBind fname happy_var_3 (fmap (,NoInfo) happy_var_4) happy_var_6 Nothing (srcspan happy_var_1 happy_var_6)
	) `HappyStk` happyRest}}}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_45 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_45 = happyReduce 5# 13# happyReduction_45
happyReduction_45 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { (L happy_var_1 LPAR) -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut15 happy_x_4 of { (HappyWrap15 happy_var_4) -> 
	case happyOutTok happy_x_5 of { (L happy_var_5 RPAR) -> 
	happyIn23
		 (let L _ (ID name) = happy_var_2 in ModParam name happy_var_4 NoInfo (srcspan happy_var_1 happy_var_5)
	) `HappyStk` happyRest}}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_46 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_46 = happySpecReduce_2  14# happyReduction_46
happyReduction_46 happy_x_2
	happy_x_1
	 =  case happyOut23 happy_x_1 of { (HappyWrap23 happy_var_1) -> 
	case happyOut24 happy_x_2 of { (HappyWrap24 happy_var_2) -> 
	happyIn24
		 (happy_var_1 : happy_var_2
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_47 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_47 = happySpecReduce_0  14# happyReduction_47
happyReduction_47  =  happyIn24
		 ([]
	)

#if __GLASGOW_HASKELL__ >= 710
happyReduce_48 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_48 = happySpecReduce_0  15# happyReduction_48
happyReduction_48  =  happyIn25
		 (Unlifted
	)

#if __GLASGOW_HASKELL__ >= 710
happyReduce_49 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_49 = happySpecReduce_1  15# happyReduction_49
happyReduction_49 happy_x_1
	 =  happyIn25
		 (SizeLifted
	)

#if __GLASGOW_HASKELL__ >= 710
happyReduce_50 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_50 = happySpecReduce_1  15# happyReduction_50
happyReduction_50 happy_x_1
	 =  happyIn25
		 (Lifted
	)

#if __GLASGOW_HASKELL__ >= 710
happyReduce_51 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_51 = happyReduce 5# 16# happyReduction_51
happyReduction_51 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { (L happy_var_1 VAL) -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut31 happy_x_3 of { (HappyWrap31 happy_var_3) -> 
	case happyOut36 happy_x_5 of { (HappyWrap36 happy_var_5) -> 
	happyIn26
		 (let L loc (ID name) = happy_var_2
          in ValSpec name happy_var_3 happy_var_5 Nothing (srcspan happy_var_1 happy_var_5)
	) `HappyStk` happyRest}}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_52 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_52 = happyReduce 5# 16# happyReduction_52
happyReduction_52 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { (L happy_var_1 VAL) -> 
	case happyOut33 happy_x_2 of { (HappyWrap33 happy_var_2) -> 
	case happyOut31 happy_x_3 of { (HappyWrap31 happy_var_3) -> 
	case happyOut36 happy_x_5 of { (HappyWrap36 happy_var_5) -> 
	happyIn26
		 (ValSpec happy_var_2 happy_var_3 happy_var_5 Nothing (srcspan happy_var_1 happy_var_5)
	) `HappyStk` happyRest}}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_53 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_53 = happySpecReduce_1  16# happyReduction_53
happyReduction_53 happy_x_1
	 =  case happyOut37 happy_x_1 of { (HappyWrap37 happy_var_1) -> 
	happyIn26
		 (TypeAbbrSpec happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_54 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_54 = happyReduce 4# 16# happyReduction_54
happyReduction_54 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { (L happy_var_1 TYPE) -> 
	case happyOut25 happy_x_2 of { (HappyWrap25 happy_var_2) -> 
	case happyOutTok happy_x_3 of { happy_var_3 -> 
	case happyOut31 happy_x_4 of { (HappyWrap31 happy_var_4) -> 
	happyIn26
		 (let L _ (ID name) = happy_var_3
          in TypeSpec happy_var_2 name happy_var_4 Nothing (srcspan happy_var_1 happy_var_4)
	) `HappyStk` happyRest}}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_55 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_55 = happyReduce 6# 16# happyReduction_55
happyReduction_55 (happy_x_6 `HappyStk`
	happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { (L happy_var_1 TYPE) -> 
	case happyOut25 happy_x_2 of { (HappyWrap25 happy_var_2) -> 
	case happyOutTok happy_x_3 of { happy_var_3 -> 
	case happyOutTok happy_x_4 of { happy_var_4 -> 
	case happyOut31 happy_x_6 of { (HappyWrap31 happy_var_6) -> 
	happyIn26
		 (let L _ (INDEXING name) = happy_var_3; L ploc (ID pname) = happy_var_4
          in TypeSpec happy_var_2 name (TypeParamDim pname ploc : happy_var_6) Nothing (srcspan happy_var_1 happy_var_6)
	) `HappyStk` happyRest}}}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_56 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_56 = happyReduce 4# 16# happyReduction_56
happyReduction_56 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { (L happy_var_1 MODULE) -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut15 happy_x_4 of { (HappyWrap15 happy_var_4) -> 
	happyIn26
		 (let L _ (ID name) = happy_var_2
          in ModSpec name happy_var_4 Nothing (srcspan happy_var_1 happy_var_4)
	) `HappyStk` happyRest}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_57 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_57 = happySpecReduce_2  16# happyReduction_57
happyReduction_57 happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { (L happy_var_1 INCLUDE) -> 
	case happyOut15 happy_x_2 of { (HappyWrap15 happy_var_2) -> 
	happyIn26
		 (IncludeSpec happy_var_2 (srcspan happy_var_1 happy_var_2)
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_58 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_58 = happySpecReduce_2  16# happyReduction_58
happyReduction_58 happy_x_2
	happy_x_1
	 =  case happyOut10 happy_x_1 of { (HappyWrap10 happy_var_1) -> 
	case happyOut26 happy_x_2 of { (HappyWrap26 happy_var_2) -> 
	happyIn26
		 (addDocSpec happy_var_1 happy_var_2
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_59 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_59 = happyReduce 4# 16# happyReduction_59
happyReduction_59 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut99 happy_x_2 of { (HappyWrap99 happy_var_2) -> 
	case happyOut26 happy_x_4 of { (HappyWrap26 happy_var_4) -> 
	happyIn26
		 (addAttrSpec happy_var_2 happy_var_4
	) `HappyStk` happyRest}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_60 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_60 = happySpecReduce_2  17# happyReduction_60
happyReduction_60 happy_x_2
	happy_x_1
	 =  case happyOut26 happy_x_1 of { (HappyWrap26 happy_var_1) -> 
	case happyOut27 happy_x_2 of { (HappyWrap27 happy_var_2) -> 
	happyIn27
		 (happy_var_1 : happy_var_2
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_61 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_61 = happySpecReduce_0  17# happyReduction_61
happyReduction_61  =  happyIn27
		 ([]
	)

#if __GLASGOW_HASKELL__ >= 710
happyReduce_62 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_62 = happySpecReduce_3  18# happyReduction_62
happyReduction_62 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { (L happy_var_1 LBRACKET) -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOutTok happy_x_3 of { (L happy_var_3 RBRACKET) -> 
	happyIn28
		 (let L _ (ID name) = happy_var_2 in SizeBinder name (srcspan happy_var_1 happy_var_3)
	)}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_63 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_63 = happySpecReduce_2  19# happyReduction_63
happyReduction_63 happy_x_2
	happy_x_1
	 =  case happyOut28 happy_x_1 of { (HappyWrap28 happy_var_1) -> 
	case happyOut29 happy_x_2 of { (HappyWrap29 happy_var_2) -> 
	happyIn29
		 (happy_var_1 : happy_var_2
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_64 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_64 = happySpecReduce_1  19# happyReduction_64
happyReduction_64 happy_x_1
	 =  case happyOut28 happy_x_1 of { (HappyWrap28 happy_var_1) -> 
	happyIn29
		 ([happy_var_1]
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_65 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_65 = happySpecReduce_3  20# happyReduction_65
happyReduction_65 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { (L happy_var_1 LBRACKET) -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOutTok happy_x_3 of { (L happy_var_3 RBRACKET) -> 
	happyIn30
		 (let L _ (ID name) = happy_var_2 in TypeParamDim name (srcspan happy_var_1 happy_var_3)
	)}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_66 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_66 = happySpecReduce_2  20# happyReduction_66
happyReduction_66 happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { (L happy_var_1 APOSTROPHE) -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	happyIn30
		 (let L _ (ID name) = happy_var_2 in TypeParamType Unlifted name (srcspan happy_var_1 happy_var_2)
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_67 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_67 = happySpecReduce_2  20# happyReduction_67
happyReduction_67 happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { (L happy_var_1 APOSTROPHE_THEN_TILDE) -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	happyIn30
		 (let L _ (ID name) = happy_var_2 in TypeParamType SizeLifted name (srcspan happy_var_1 happy_var_2)
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_68 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_68 = happySpecReduce_2  20# happyReduction_68
happyReduction_68 happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { (L happy_var_1 APOSTROPHE_THEN_HAT) -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	happyIn30
		 (let L _ (ID name) = happy_var_2 in TypeParamType Lifted name (srcspan happy_var_1 happy_var_2)
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_69 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_69 = happySpecReduce_2  21# happyReduction_69
happyReduction_69 happy_x_2
	happy_x_1
	 =  case happyOut30 happy_x_1 of { (HappyWrap30 happy_var_1) -> 
	case happyOut31 happy_x_2 of { (HappyWrap31 happy_var_2) -> 
	happyIn31
		 (happy_var_1 : happy_var_2
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_70 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_70 = happySpecReduce_0  21# happyReduction_70
happyReduction_70  =  happyIn31
		 ([]
	)

#if __GLASGOW_HASKELL__ >= 710
happyReduce_71 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_71 = happySpecReduce_1  22# happyReduction_71
happyReduction_71 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn32
		 (binOpName happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_72 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_72 = happySpecReduce_1  22# happyReduction_72
happyReduction_72 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn32
		 (binOpName happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_73 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_73 = happySpecReduce_1  22# happyReduction_73
happyReduction_73 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn32
		 (binOpName happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_74 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_74 = happySpecReduce_1  22# happyReduction_74
happyReduction_74 happy_x_1
	 =  case happyOutTok happy_x_1 of { (L happy_var_1 ASTERISK) -> 
	happyIn32
		 ((qualName (nameFromString "*"), happy_var_1)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_75 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_75 = happySpecReduce_1  22# happyReduction_75
happyReduction_75 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn32
		 (binOpName happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_76 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_76 = happySpecReduce_1  22# happyReduction_76
happyReduction_76 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn32
		 (binOpName happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_77 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_77 = happySpecReduce_1  22# happyReduction_77
happyReduction_77 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn32
		 (binOpName happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_78 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_78 = happySpecReduce_1  22# happyReduction_78
happyReduction_78 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn32
		 (binOpName happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_79 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_79 = happySpecReduce_1  22# happyReduction_79
happyReduction_79 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn32
		 (binOpName happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_80 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_80 = happySpecReduce_1  22# happyReduction_80
happyReduction_80 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn32
		 (binOpName happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_81 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_81 = happySpecReduce_1  22# happyReduction_81
happyReduction_81 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn32
		 (binOpName happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_82 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_82 = happySpecReduce_1  22# happyReduction_82
happyReduction_82 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn32
		 (binOpName happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_83 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_83 = happySpecReduce_1  22# happyReduction_83
happyReduction_83 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn32
		 (binOpName happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_84 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_84 = happySpecReduce_1  22# happyReduction_84
happyReduction_84 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn32
		 (binOpName happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_85 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_85 = happySpecReduce_1  22# happyReduction_85
happyReduction_85 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn32
		 (binOpName happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_86 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_86 = happySpecReduce_1  22# happyReduction_86
happyReduction_86 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn32
		 (binOpName happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_87 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_87 = happySpecReduce_1  22# happyReduction_87
happyReduction_87 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn32
		 (binOpName happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_88 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_88 = happySpecReduce_1  22# happyReduction_88
happyReduction_88 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn32
		 (binOpName happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_89 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_89 = happySpecReduce_1  22# happyReduction_89
happyReduction_89 happy_x_1
	 =  case happyOutTok happy_x_1 of { (L happy_var_1 HAT) -> 
	happyIn32
		 ((qualName (nameFromString "^"), happy_var_1)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_90 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_90 = happySpecReduce_1  22# happyReduction_90
happyReduction_90 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn32
		 (binOpName happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_91 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_91 = happySpecReduce_1  22# happyReduction_91
happyReduction_91 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn32
		 (binOpName happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_92 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_92 = happySpecReduce_1  22# happyReduction_92
happyReduction_92 happy_x_1
	 =  case happyOutTok happy_x_1 of { (L happy_var_1 PIPE) -> 
	happyIn32
		 ((qualName (nameFromString "|"), happy_var_1)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_93 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_93 = happySpecReduce_1  22# happyReduction_93
happyReduction_93 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn32
		 (binOpName happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_94 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_94 = happySpecReduce_1  22# happyReduction_94
happyReduction_94 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn32
		 (binOpName happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_95 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_95 = happySpecReduce_1  22# happyReduction_95
happyReduction_95 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn32
		 (binOpName happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_96 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_96 = happySpecReduce_1  22# happyReduction_96
happyReduction_96 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn32
		 (binOpName happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_97 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_97 = happySpecReduce_1  22# happyReduction_97
happyReduction_97 happy_x_1
	 =  case happyOutTok happy_x_1 of { (L happy_var_1 LTH) -> 
	happyIn32
		 ((qualName (nameFromString "<"), happy_var_1)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_98 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_98 = happySpecReduce_3  22# happyReduction_98
happyReduction_98 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut55 happy_x_2 of { (HappyWrap55 happy_var_2) -> 
	happyIn32
		 (happy_var_2
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_99 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_99 = happyMonadReduce 1# 23# happyReduction_99
happyReduction_99 (happy_x_1 `HappyStk`
	happyRest) tk
	 = happyThen ((case happyOut32 happy_x_1 of { (HappyWrap32 happy_var_1) -> 
	( let (QualName qs name, loc) = happy_var_1 in do
                   unless (null qs) $ parseErrorAt loc $
                     Just "Cannot use a qualified name in binding position."
                   return name)})
	) (\r -> happyReturn (happyIn33 r))

#if __GLASGOW_HASKELL__ >= 710
happyReduce_100 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_100 = happySpecReduce_1  23# happyReduction_100
happyReduction_100 happy_x_1
	 =  happyIn33
		 (nameFromString "-"
	)

#if __GLASGOW_HASKELL__ >= 710
happyReduce_101 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_101 = happySpecReduce_1  24# happyReduction_101
happyReduction_101 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn34
		 (let L loc (ID name) = happy_var_1 in (name, loc)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_102 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_102 = happySpecReduce_3  24# happyReduction_102
happyReduction_102 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { (L happy_var_1 LPAR) -> 
	case happyOut33 happy_x_2 of { (HappyWrap33 happy_var_2) -> 
	happyIn34
		 ((happy_var_2, happy_var_1)
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_103 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_103 = happyReduce 7# 25# happyReduction_103
happyReduction_103 (happy_x_7 `HappyStk`
	happy_x_6 `HappyStk`
	happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { (L happy_var_1 DEF) -> 
	case happyOut34 happy_x_2 of { (HappyWrap34 happy_var_2) -> 
	case happyOut31 happy_x_3 of { (HappyWrap31 happy_var_3) -> 
	case happyOut54 happy_x_4 of { (HappyWrap54 happy_var_4) -> 
	case happyOut117 happy_x_5 of { happy_var_5 -> 
	case happyOut56 happy_x_7 of { (HappyWrap56 happy_var_7) -> 
	happyIn35
		 (let (name, _) = happy_var_2
            in ValBind Nothing name (fmap declaredType happy_var_5) NoInfo
               happy_var_3 happy_var_4 happy_var_7 Nothing mempty (srcspan happy_var_1 happy_var_7)
	) `HappyStk` happyRest}}}}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_104 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_104 = happyReduce 7# 25# happyReduction_104
happyReduction_104 (happy_x_7 `HappyStk`
	happy_x_6 `HappyStk`
	happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { (L happy_var_1 ENTRY) -> 
	case happyOut34 happy_x_2 of { (HappyWrap34 happy_var_2) -> 
	case happyOut31 happy_x_3 of { (HappyWrap31 happy_var_3) -> 
	case happyOut54 happy_x_4 of { (HappyWrap54 happy_var_4) -> 
	case happyOut117 happy_x_5 of { happy_var_5 -> 
	case happyOut56 happy_x_7 of { (HappyWrap56 happy_var_7) -> 
	happyIn35
		 (let (name, loc) = happy_var_2
            in ValBind (Just NoInfo) name (fmap declaredType happy_var_5) NoInfo
               happy_var_3 happy_var_4 happy_var_7 Nothing mempty (srcspan happy_var_1 happy_var_7)
	) `HappyStk` happyRest}}}}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_105 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_105 = happyReduce 7# 25# happyReduction_105
happyReduction_105 (happy_x_7 `HappyStk`
	happy_x_6 `HappyStk`
	happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { (L happy_var_1 DEF) -> 
	case happyOut52 happy_x_2 of { (HappyWrap52 happy_var_2) -> 
	case happyOut33 happy_x_3 of { (HappyWrap33 happy_var_3) -> 
	case happyOut52 happy_x_4 of { (HappyWrap52 happy_var_4) -> 
	case happyOut117 happy_x_5 of { happy_var_5 -> 
	case happyOut56 happy_x_7 of { (HappyWrap56 happy_var_7) -> 
	happyIn35
		 (ValBind Nothing happy_var_3 (fmap declaredType happy_var_5) NoInfo [] [happy_var_2,happy_var_4] happy_var_7
            Nothing mempty (srcspan happy_var_1 happy_var_7)
	) `HappyStk` happyRest}}}}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_106 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_106 = happyReduce 7# 25# happyReduction_106
happyReduction_106 (happy_x_7 `HappyStk`
	happy_x_6 `HappyStk`
	happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { (L happy_var_1 LET) -> 
	case happyOut34 happy_x_2 of { (HappyWrap34 happy_var_2) -> 
	case happyOut31 happy_x_3 of { (HappyWrap31 happy_var_3) -> 
	case happyOut54 happy_x_4 of { (HappyWrap54 happy_var_4) -> 
	case happyOut117 happy_x_5 of { happy_var_5 -> 
	case happyOut56 happy_x_7 of { (HappyWrap56 happy_var_7) -> 
	happyIn35
		 (let (name, _) = happy_var_2
            in ValBind Nothing name (fmap declaredType happy_var_5) NoInfo
               happy_var_3 happy_var_4 happy_var_7 Nothing mempty (srcspan happy_var_1 happy_var_7)
	) `HappyStk` happyRest}}}}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_107 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_107 = happyReduce 7# 25# happyReduction_107
happyReduction_107 (happy_x_7 `HappyStk`
	happy_x_6 `HappyStk`
	happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { (L happy_var_1 LET) -> 
	case happyOut52 happy_x_2 of { (HappyWrap52 happy_var_2) -> 
	case happyOut33 happy_x_3 of { (HappyWrap33 happy_var_3) -> 
	case happyOut52 happy_x_4 of { (HappyWrap52 happy_var_4) -> 
	case happyOut117 happy_x_5 of { happy_var_5 -> 
	case happyOut56 happy_x_7 of { (HappyWrap56 happy_var_7) -> 
	happyIn35
		 (ValBind Nothing happy_var_3 (fmap declaredType happy_var_5) NoInfo [] [happy_var_2,happy_var_4] happy_var_7
            Nothing mempty (srcspan happy_var_1 happy_var_7)
	) `HappyStk` happyRest}}}}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_108 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_108 = happySpecReduce_1  26# happyReduction_108
happyReduction_108 happy_x_1
	 =  case happyOut38 happy_x_1 of { (HappyWrap38 happy_var_1) -> 
	happyIn36
		 (TypeDecl happy_var_1 NoInfo
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_109 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_109 = happyReduce 6# 27# happyReduction_109
happyReduction_109 (happy_x_6 `HappyStk`
	happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { (L happy_var_1 TYPE) -> 
	case happyOut25 happy_x_2 of { (HappyWrap25 happy_var_2) -> 
	case happyOutTok happy_x_3 of { happy_var_3 -> 
	case happyOut31 happy_x_4 of { (HappyWrap31 happy_var_4) -> 
	case happyOut38 happy_x_6 of { (HappyWrap38 happy_var_6) -> 
	happyIn37
		 (let L _ (ID name) = happy_var_3
              in TypeBind name happy_var_2 happy_var_4 happy_var_6 NoInfo Nothing (srcspan happy_var_1 happy_var_6)
	) `HappyStk` happyRest}}}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_110 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_110 = happyReduce 8# 27# happyReduction_110
happyReduction_110 (happy_x_8 `HappyStk`
	happy_x_7 `HappyStk`
	happy_x_6 `HappyStk`
	happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { (L happy_var_1 TYPE) -> 
	case happyOut25 happy_x_2 of { (HappyWrap25 happy_var_2) -> 
	case happyOutTok happy_x_3 of { happy_var_3 -> 
	case happyOutTok happy_x_4 of { happy_var_4 -> 
	case happyOut31 happy_x_6 of { (HappyWrap31 happy_var_6) -> 
	case happyOut38 happy_x_8 of { (HappyWrap38 happy_var_8) -> 
	happyIn37
		 (let L loc (INDEXING name) = happy_var_3; L ploc (ID pname) = happy_var_4
             in TypeBind name happy_var_2 (TypeParamDim pname ploc:happy_var_6) happy_var_8 NoInfo Nothing (srcspan happy_var_1 happy_var_8)
	) `HappyStk` happyRest}}}}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_111 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_111 = happyReduce 7# 28# happyReduction_111
happyReduction_111 (happy_x_7 `HappyStk`
	happy_x_6 `HappyStk`
	happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { (L happy_var_1 LPAR) -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut38 happy_x_4 of { (HappyWrap38 happy_var_4) -> 
	case happyOut38 happy_x_7 of { (HappyWrap38 happy_var_7) -> 
	happyIn38
		 (let L _ (ID v) = happy_var_2 in TEArrow (Just v) happy_var_4 happy_var_7 (srcspan happy_var_1 happy_var_7)
	) `HappyStk` happyRest}}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_112 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_112 = happySpecReduce_3  28# happyReduction_112
happyReduction_112 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut40 happy_x_1 of { (HappyWrap40 happy_var_1) -> 
	case happyOut38 happy_x_3 of { (HappyWrap38 happy_var_3) -> 
	happyIn38
		 (TEArrow Nothing happy_var_1 happy_var_3 (srcspan happy_var_1 happy_var_3)
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_113 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_113 = happyReduce 4# 28# happyReduction_113
happyReduction_113 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { (L happy_var_1 QUESTION_MARK) -> 
	case happyOut39 happy_x_2 of { (HappyWrap39 happy_var_2) -> 
	case happyOut38 happy_x_4 of { (HappyWrap38 happy_var_4) -> 
	happyIn38
		 (TEDim happy_var_2 happy_var_4 (srcspan happy_var_1 happy_var_4)
	) `HappyStk` happyRest}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_114 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_114 = happySpecReduce_1  28# happyReduction_114
happyReduction_114 happy_x_1
	 =  case happyOut40 happy_x_1 of { (HappyWrap40 happy_var_1) -> 
	happyIn38
		 (happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_115 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_115 = happySpecReduce_3  29# happyReduction_115
happyReduction_115 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_2 of { happy_var_2 -> 
	happyIn39
		 (let L _ (ID v) = happy_var_2 in [v]
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_116 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_116 = happyReduce 4# 29# happyReduction_116
happyReduction_116 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut39 happy_x_4 of { (HappyWrap39 happy_var_4) -> 
	happyIn39
		 (let L _ (ID v) = happy_var_2 in v : happy_var_4
	) `HappyStk` happyRest}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_117 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_117 = happySpecReduce_2  30# happyReduction_117
happyReduction_117 happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { (L happy_var_1 ASTERISK) -> 
	case happyOut40 happy_x_2 of { (HappyWrap40 happy_var_2) -> 
	happyIn40
		 (TEUnique happy_var_2 (srcspan happy_var_1 happy_var_2)
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_118 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_118 = happyReduce 4# 30# happyReduction_118
happyReduction_118 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { (L happy_var_1 LBRACKET) -> 
	case happyOut51 happy_x_2 of { (HappyWrap51 happy_var_2) -> 
	case happyOut40 happy_x_4 of { (HappyWrap40 happy_var_4) -> 
	happyIn40
		 (TEArray happy_var_4 happy_var_2 (srcspan happy_var_1 happy_var_4)
	) `HappyStk` happyRest}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_119 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_119 = happySpecReduce_3  30# happyReduction_119
happyReduction_119 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { (L happy_var_1 LBRACKET) -> 
	case happyOut40 happy_x_3 of { (HappyWrap40 happy_var_3) -> 
	happyIn40
		 (TEArray happy_var_3 DimExpAny (srcspan happy_var_1 happy_var_3)
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_120 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_120 = happySpecReduce_1  30# happyReduction_120
happyReduction_120 happy_x_1
	 =  case happyOut44 happy_x_1 of { (HappyWrap44 happy_var_1) -> 
	happyIn40
		 (happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_121 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_121 = happyMonadReduce 3# 30# happyReduction_121
happyReduction_121 (happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest) tk
	 = happyThen ((case happyOutTok happy_x_1 of { (L happy_var_1 LBRACKET) -> 
	case happyOut51 happy_x_2 of { (HappyWrap51 happy_var_2) -> 
	case happyOutTok happy_x_3 of { (L happy_var_3 RBRACKET) -> 
	( parseErrorAt (srcspan happy_var_1 happy_var_3) $ Just $
                unlines ["missing array row type.",
                         "Did you mean []"  ++ pretty happy_var_2 ++ "?"])}}})
	) (\r -> happyReturn (happyIn40 r))

#if __GLASGOW_HASKELL__ >= 710
happyReduce_122 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_122 = happySpecReduce_1  31# happyReduction_122
happyReduction_122 happy_x_1
	 =  case happyOut42 happy_x_1 of { (HappyWrap42 happy_var_1) -> 
	happyIn41
		 (let (cs, loc) = happy_var_1
                        in TESum cs loc
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_123 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_123 = happySpecReduce_3  32# happyReduction_123
happyReduction_123 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut42 happy_x_1 of { (HappyWrap42 happy_var_1) -> 
	case happyOut43 happy_x_3 of { (HappyWrap43 happy_var_3) -> 
	happyIn42
		 (let (cs, loc1) = happy_var_1;
                                             (c, ts, loc2) = happy_var_3
                                          in (cs++[(c, ts)], srcspan loc1 loc2)
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_124 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_124 = happySpecReduce_1  32# happyReduction_124
happyReduction_124 happy_x_1
	 =  case happyOut43 happy_x_1 of { (HappyWrap43 happy_var_1) -> 
	happyIn42
		 (let (n, ts, loc) = happy_var_1
                                        in ([(n, ts)], loc)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_125 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_125 = happySpecReduce_2  33# happyReduction_125
happyReduction_125 happy_x_2
	happy_x_1
	 =  case happyOut43 happy_x_1 of { (HappyWrap43 happy_var_1) -> 
	case happyOut45 happy_x_2 of { (HappyWrap45 happy_var_2) -> 
	happyIn43
		 (let (n, ts, loc) = happy_var_1
                                     in (n, ts ++ [happy_var_2], srcspan loc happy_var_2)
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_126 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_126 = happySpecReduce_1  33# happyReduction_126
happyReduction_126 happy_x_1
	 =  case happyOut46 happy_x_1 of { (HappyWrap46 happy_var_1) -> 
	happyIn43
		 ((fst happy_var_1, [], snd happy_var_1)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_127 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_127 = happySpecReduce_2  34# happyReduction_127
happyReduction_127 happy_x_2
	happy_x_1
	 =  case happyOut44 happy_x_1 of { (HappyWrap44 happy_var_1) -> 
	case happyOut47 happy_x_2 of { (HappyWrap47 happy_var_2) -> 
	happyIn44
		 (TEApply happy_var_1 happy_var_2 (srcspan happy_var_1 happy_var_2)
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_128 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_128 = happySpecReduce_3  34# happyReduction_128
happyReduction_128 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut51 happy_x_2 of { (HappyWrap51 happy_var_2) -> 
	case happyOutTok happy_x_3 of { (L happy_var_3 RBRACKET) -> 
	happyIn44
		 (let L loc (INDEXING v) = happy_var_1
                  in TEApply (TEVar (qualName v) loc) (TypeArgExpDim happy_var_2 loc) (srcspan happy_var_1 happy_var_3)
	)}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_129 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_129 = happySpecReduce_3  34# happyReduction_129
happyReduction_129 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut51 happy_x_2 of { (HappyWrap51 happy_var_2) -> 
	case happyOutTok happy_x_3 of { (L happy_var_3 RBRACKET) -> 
	happyIn44
		 (let L loc (QUALINDEXING qs v) = happy_var_1
                  in TEApply (TEVar (QualName qs v) loc) (TypeArgExpDim happy_var_2 loc) (srcspan happy_var_1 happy_var_3)
	)}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_130 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_130 = happySpecReduce_1  34# happyReduction_130
happyReduction_130 happy_x_1
	 =  case happyOut45 happy_x_1 of { (HappyWrap45 happy_var_1) -> 
	happyIn44
		 (happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_131 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_131 = happySpecReduce_3  35# happyReduction_131
happyReduction_131 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut38 happy_x_2 of { (HappyWrap38 happy_var_2) -> 
	happyIn45
		 (happy_var_2
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_132 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_132 = happySpecReduce_2  35# happyReduction_132
happyReduction_132 happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { (L happy_var_1 LPAR) -> 
	case happyOutTok happy_x_2 of { (L happy_var_2 RPAR) -> 
	happyIn45
		 (TETuple [] (srcspan happy_var_1 happy_var_2)
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_133 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_133 = happyReduce 5# 35# happyReduction_133
happyReduction_133 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { (L happy_var_1 LPAR) -> 
	case happyOut38 happy_x_2 of { (HappyWrap38 happy_var_2) -> 
	case happyOut50 happy_x_4 of { (HappyWrap50 happy_var_4) -> 
	case happyOutTok happy_x_5 of { (L happy_var_5 RPAR) -> 
	happyIn45
		 (TETuple (happy_var_2:happy_var_4) (srcspan happy_var_1 happy_var_5)
	) `HappyStk` happyRest}}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_134 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_134 = happySpecReduce_2  35# happyReduction_134
happyReduction_134 happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { (L happy_var_1 LCURLY) -> 
	case happyOutTok happy_x_2 of { (L happy_var_2 RCURLY) -> 
	happyIn45
		 (TERecord [] (srcspan happy_var_1 happy_var_2)
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_135 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_135 = happySpecReduce_3  35# happyReduction_135
happyReduction_135 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { (L happy_var_1 LCURLY) -> 
	case happyOut49 happy_x_2 of { (HappyWrap49 happy_var_2) -> 
	case happyOutTok happy_x_3 of { (L happy_var_3 RCURLY) -> 
	happyIn45
		 (TERecord happy_var_2 (srcspan happy_var_1 happy_var_3)
	)}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_136 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_136 = happySpecReduce_1  35# happyReduction_136
happyReduction_136 happy_x_1
	 =  case happyOut55 happy_x_1 of { (HappyWrap55 happy_var_1) -> 
	happyIn45
		 (TEVar (fst happy_var_1) (snd happy_var_1)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_137 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_137 = happySpecReduce_1  35# happyReduction_137
happyReduction_137 happy_x_1
	 =  case happyOut41 happy_x_1 of { (HappyWrap41 happy_var_1) -> 
	happyIn45
		 (happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_138 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_138 = happySpecReduce_1  36# happyReduction_138
happyReduction_138 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn46
		 (let L _ (CONSTRUCTOR c) = happy_var_1 in (c, srclocOf happy_var_1)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_139 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_139 = happySpecReduce_3  37# happyReduction_139
happyReduction_139 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { (L happy_var_1 LBRACKET) -> 
	case happyOut51 happy_x_2 of { (HappyWrap51 happy_var_2) -> 
	case happyOutTok happy_x_3 of { (L happy_var_3 RBRACKET) -> 
	happyIn47
		 (TypeArgExpDim happy_var_2 (srcspan happy_var_1 happy_var_3)
	)}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_140 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_140 = happySpecReduce_2  37# happyReduction_140
happyReduction_140 happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { (L happy_var_1 LBRACKET) -> 
	case happyOutTok happy_x_2 of { (L happy_var_2 RBRACKET) -> 
	happyIn47
		 (TypeArgExpDim DimExpAny (srcspan happy_var_1 happy_var_2)
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_141 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_141 = happySpecReduce_1  37# happyReduction_141
happyReduction_141 happy_x_1
	 =  case happyOut45 happy_x_1 of { (HappyWrap45 happy_var_1) -> 
	happyIn47
		 (TypeArgExpType happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_142 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_142 = happySpecReduce_3  38# happyReduction_142
happyReduction_142 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut91 happy_x_1 of { (HappyWrap91 happy_var_1) -> 
	case happyOut38 happy_x_3 of { (HappyWrap38 happy_var_3) -> 
	happyIn48
		 ((fst happy_var_1, happy_var_3)
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_143 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_143 = happySpecReduce_1  39# happyReduction_143
happyReduction_143 happy_x_1
	 =  case happyOut48 happy_x_1 of { (HappyWrap48 happy_var_1) -> 
	happyIn49
		 ([happy_var_1]
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_144 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_144 = happySpecReduce_3  39# happyReduction_144
happyReduction_144 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut48 happy_x_1 of { (HappyWrap48 happy_var_1) -> 
	case happyOut49 happy_x_3 of { (HappyWrap49 happy_var_3) -> 
	happyIn49
		 (happy_var_1 : happy_var_3
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_145 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_145 = happySpecReduce_1  40# happyReduction_145
happyReduction_145 happy_x_1
	 =  case happyOut38 happy_x_1 of { (HappyWrap38 happy_var_1) -> 
	happyIn50
		 ([happy_var_1]
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_146 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_146 = happySpecReduce_3  40# happyReduction_146
happyReduction_146 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut38 happy_x_1 of { (HappyWrap38 happy_var_1) -> 
	case happyOut50 happy_x_3 of { (HappyWrap50 happy_var_3) -> 
	happyIn50
		 (happy_var_1 : happy_var_3
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_147 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_147 = happySpecReduce_1  41# happyReduction_147
happyReduction_147 happy_x_1
	 =  case happyOut55 happy_x_1 of { (HappyWrap55 happy_var_1) -> 
	happyIn51
		 (DimExpNamed (fst happy_var_1) (snd happy_var_1)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_148 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_148 = happySpecReduce_1  41# happyReduction_148
happyReduction_148 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn51
		 (let L loc (INTLIT n) = happy_var_1
            in DimExpConst (fromIntegral n) loc
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_149 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_149 = happySpecReduce_1  42# happyReduction_149
happyReduction_149 happy_x_1
	 =  case happyOut94 happy_x_1 of { (HappyWrap94 happy_var_1) -> 
	happyIn52
		 (happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_150 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_150 = happySpecReduce_1  43# happyReduction_150
happyReduction_150 happy_x_1
	 =  case happyOut52 happy_x_1 of { (HappyWrap52 happy_var_1) -> 
	happyIn53
		 ((happy_var_1, [])
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_151 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_151 = happySpecReduce_2  43# happyReduction_151
happyReduction_151 happy_x_2
	happy_x_1
	 =  case happyOut52 happy_x_1 of { (HappyWrap52 happy_var_1) -> 
	case happyOut53 happy_x_2 of { (HappyWrap53 happy_var_2) -> 
	happyIn53
		 ((happy_var_1, fst happy_var_2 : snd happy_var_2)
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_152 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_152 = happySpecReduce_0  44# happyReduction_152
happyReduction_152  =  happyIn54
		 ([]
	)

#if __GLASGOW_HASKELL__ >= 710
happyReduce_153 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_153 = happySpecReduce_2  44# happyReduction_153
happyReduction_153 happy_x_2
	happy_x_1
	 =  case happyOut52 happy_x_1 of { (HappyWrap52 happy_var_1) -> 
	case happyOut54 happy_x_2 of { (HappyWrap54 happy_var_2) -> 
	happyIn54
		 (happy_var_1 : happy_var_2
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_154 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_154 = happySpecReduce_2  45# happyReduction_154
happyReduction_154 happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut66 happy_x_2 of { (HappyWrap66 happy_var_2) -> 
	happyIn55
		 (let L vloc (ID v) = happy_var_1 in
              foldl (\(QualName qs v', loc) (y, yloc) ->
                      (QualName (qs ++ [v']) y, srcspan loc yloc))
                    (qualName v, vloc) happy_var_2
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_155 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_155 = happySpecReduce_3  46# happyReduction_155
happyReduction_155 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut56 happy_x_1 of { (HappyWrap56 happy_var_1) -> 
	case happyOut36 happy_x_3 of { (HappyWrap36 happy_var_3) -> 
	happyIn56
		 (Ascript happy_var_1 happy_var_3 (srcspan happy_var_1 happy_var_3)
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_156 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_156 = happySpecReduce_3  46# happyReduction_156
happyReduction_156 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut56 happy_x_1 of { (HappyWrap56 happy_var_1) -> 
	case happyOut36 happy_x_3 of { (HappyWrap36 happy_var_3) -> 
	happyIn56
		 (AppExp (Coerce happy_var_1 happy_var_3 (srcspan happy_var_1 happy_var_3)) NoInfo
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_157 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_157 = happySpecReduce_1  46# happyReduction_157
happyReduction_157 happy_x_1
	 =  case happyOut57 happy_x_1 of { (HappyWrap57 happy_var_1) -> 
	happyIn56
		 (happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_158 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_158 = happyReduce 6# 47# happyReduction_158
happyReduction_158 (happy_x_6 `HappyStk`
	happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { (L happy_var_1 IF) -> 
	case happyOut56 happy_x_2 of { (HappyWrap56 happy_var_2) -> 
	case happyOut56 happy_x_4 of { (HappyWrap56 happy_var_4) -> 
	case happyOut56 happy_x_6 of { (HappyWrap56 happy_var_6) -> 
	happyIn57
		 (AppExp (If happy_var_2 happy_var_4 happy_var_6 (srcspan happy_var_1 happy_var_6)) NoInfo
	) `HappyStk` happyRest}}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_159 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_159 = happyMonadReduce 5# 47# happyReduction_159
happyReduction_159 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest) tk
	 = happyThen ((case happyOutTok happy_x_1 of { (L happy_var_1 LOOP) -> 
	case happyOut92 happy_x_2 of { (HappyWrap92 happy_var_2) -> 
	case happyOut84 happy_x_3 of { (HappyWrap84 happy_var_3) -> 
	case happyOut56 happy_x_5 of { (HappyWrap56 happy_var_5) -> 
	( fmap (\t -> AppExp (DoLoop [] happy_var_2 t happy_var_3 happy_var_5 (srcspan happy_var_1 happy_var_5)) NoInfo) (patternExp happy_var_2))}}}})
	) (\r -> happyReturn (happyIn57 r))

#if __GLASGOW_HASKELL__ >= 710
happyReduce_160 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_160 = happyReduce 7# 47# happyReduction_160
happyReduction_160 (happy_x_7 `HappyStk`
	happy_x_6 `HappyStk`
	happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { (L happy_var_1 LOOP) -> 
	case happyOut92 happy_x_2 of { (HappyWrap92 happy_var_2) -> 
	case happyOut56 happy_x_4 of { (HappyWrap56 happy_var_4) -> 
	case happyOut84 happy_x_5 of { (HappyWrap84 happy_var_5) -> 
	case happyOut56 happy_x_7 of { (HappyWrap56 happy_var_7) -> 
	happyIn57
		 (AppExp (DoLoop [] happy_var_2 happy_var_4 happy_var_5 happy_var_7 (srcspan happy_var_1 happy_var_7)) NoInfo
	) `HappyStk` happyRest}}}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_161 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_161 = happySpecReduce_1  47# happyReduction_161
happyReduction_161 happy_x_1
	 =  case happyOut71 happy_x_1 of { (HappyWrap71 happy_var_1) -> 
	happyIn57
		 (happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_162 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_162 = happySpecReduce_1  47# happyReduction_162
happyReduction_162 happy_x_1
	 =  case happyOut73 happy_x_1 of { (HappyWrap73 happy_var_1) -> 
	happyIn57
		 (happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_163 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_163 = happySpecReduce_3  47# happyReduction_163
happyReduction_163 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { (L happy_var_1 ASSERT) -> 
	case happyOut60 happy_x_2 of { (HappyWrap60 happy_var_2) -> 
	case happyOut60 happy_x_3 of { (HappyWrap60 happy_var_3) -> 
	happyIn57
		 (Assert happy_var_2 happy_var_3 NoInfo (srcspan happy_var_1 happy_var_3)
	)}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_164 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_164 = happyReduce 4# 47# happyReduction_164
happyReduction_164 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { (L happy_var_1 HASH_LBRACKET) -> 
	case happyOut99 happy_x_2 of { (HappyWrap99 happy_var_2) -> 
	case happyOut56 happy_x_4 of { (HappyWrap56 happy_var_4) -> 
	happyIn57
		 (Attr happy_var_2 happy_var_4 (srcspan happy_var_1 happy_var_4)
	) `HappyStk` happyRest}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_165 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_165 = happySpecReduce_3  47# happyReduction_165
happyReduction_165 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { (HappyWrap57 happy_var_1) -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { (HappyWrap57 happy_var_3) -> 
	happyIn57
		 (binOp happy_var_1 happy_var_2 happy_var_3
	)}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_166 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_166 = happySpecReduce_3  47# happyReduction_166
happyReduction_166 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { (HappyWrap57 happy_var_1) -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { (HappyWrap57 happy_var_3) -> 
	happyIn57
		 (binOp happy_var_1 happy_var_2 happy_var_3
	)}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_167 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_167 = happySpecReduce_3  47# happyReduction_167
happyReduction_167 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { (HappyWrap57 happy_var_1) -> 
	case happyOutTok happy_x_2 of { (L happy_var_2 NEGATE) -> 
	case happyOut57 happy_x_3 of { (HappyWrap57 happy_var_3) -> 
	happyIn57
		 (binOp happy_var_1 (L happy_var_2 (SYMBOL Minus [] (nameFromString "-"))) happy_var_3
	)}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_168 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_168 = happySpecReduce_3  47# happyReduction_168
happyReduction_168 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { (HappyWrap57 happy_var_1) -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { (HappyWrap57 happy_var_3) -> 
	happyIn57
		 (binOp happy_var_1 happy_var_2 happy_var_3
	)}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_169 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_169 = happySpecReduce_3  47# happyReduction_169
happyReduction_169 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { (HappyWrap57 happy_var_1) -> 
	case happyOutTok happy_x_2 of { (L happy_var_2 ASTERISK) -> 
	case happyOut57 happy_x_3 of { (HappyWrap57 happy_var_3) -> 
	happyIn57
		 (binOp happy_var_1 (L happy_var_2 (SYMBOL Times [] (nameFromString "*"))) happy_var_3
	)}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_170 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_170 = happySpecReduce_3  47# happyReduction_170
happyReduction_170 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { (HappyWrap57 happy_var_1) -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { (HappyWrap57 happy_var_3) -> 
	happyIn57
		 (binOp happy_var_1 happy_var_2 happy_var_3
	)}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_171 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_171 = happySpecReduce_3  47# happyReduction_171
happyReduction_171 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { (HappyWrap57 happy_var_1) -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { (HappyWrap57 happy_var_3) -> 
	happyIn57
		 (binOp happy_var_1 happy_var_2 happy_var_3
	)}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_172 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_172 = happySpecReduce_3  47# happyReduction_172
happyReduction_172 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { (HappyWrap57 happy_var_1) -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { (HappyWrap57 happy_var_3) -> 
	happyIn57
		 (binOp happy_var_1 happy_var_2 happy_var_3
	)}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_173 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_173 = happySpecReduce_3  47# happyReduction_173
happyReduction_173 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { (HappyWrap57 happy_var_1) -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { (HappyWrap57 happy_var_3) -> 
	happyIn57
		 (binOp happy_var_1 happy_var_2 happy_var_3
	)}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_174 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_174 = happySpecReduce_3  47# happyReduction_174
happyReduction_174 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { (HappyWrap57 happy_var_1) -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { (HappyWrap57 happy_var_3) -> 
	happyIn57
		 (binOp happy_var_1 happy_var_2 happy_var_3
	)}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_175 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_175 = happySpecReduce_3  47# happyReduction_175
happyReduction_175 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { (HappyWrap57 happy_var_1) -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { (HappyWrap57 happy_var_3) -> 
	happyIn57
		 (binOp happy_var_1 happy_var_2 happy_var_3
	)}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_176 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_176 = happySpecReduce_3  47# happyReduction_176
happyReduction_176 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { (HappyWrap57 happy_var_1) -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { (HappyWrap57 happy_var_3) -> 
	happyIn57
		 (binOp happy_var_1 happy_var_2 happy_var_3
	)}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_177 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_177 = happySpecReduce_3  47# happyReduction_177
happyReduction_177 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { (HappyWrap57 happy_var_1) -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { (HappyWrap57 happy_var_3) -> 
	happyIn57
		 (binOp happy_var_1 happy_var_2 happy_var_3
	)}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_178 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_178 = happySpecReduce_3  47# happyReduction_178
happyReduction_178 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { (HappyWrap57 happy_var_1) -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { (HappyWrap57 happy_var_3) -> 
	happyIn57
		 (binOp happy_var_1 happy_var_2 happy_var_3
	)}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_179 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_179 = happySpecReduce_3  47# happyReduction_179
happyReduction_179 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { (HappyWrap57 happy_var_1) -> 
	case happyOutTok happy_x_2 of { (L happy_var_2 PIPE) -> 
	case happyOut57 happy_x_3 of { (HappyWrap57 happy_var_3) -> 
	happyIn57
		 (binOp happy_var_1 (L happy_var_2 (SYMBOL Bor [] (nameFromString "|"))) happy_var_3
	)}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_180 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_180 = happySpecReduce_3  47# happyReduction_180
happyReduction_180 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { (HappyWrap57 happy_var_1) -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { (HappyWrap57 happy_var_3) -> 
	happyIn57
		 (binOp happy_var_1 happy_var_2 happy_var_3
	)}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_181 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_181 = happySpecReduce_3  47# happyReduction_181
happyReduction_181 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { (HappyWrap57 happy_var_1) -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { (HappyWrap57 happy_var_3) -> 
	happyIn57
		 (binOp happy_var_1 happy_var_2 happy_var_3
	)}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_182 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_182 = happySpecReduce_3  47# happyReduction_182
happyReduction_182 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { (HappyWrap57 happy_var_1) -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { (HappyWrap57 happy_var_3) -> 
	happyIn57
		 (binOp happy_var_1 happy_var_2 happy_var_3
	)}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_183 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_183 = happySpecReduce_3  47# happyReduction_183
happyReduction_183 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { (HappyWrap57 happy_var_1) -> 
	case happyOutTok happy_x_2 of { (L happy_var_2 HAT) -> 
	case happyOut57 happy_x_3 of { (HappyWrap57 happy_var_3) -> 
	happyIn57
		 (binOp happy_var_1 (L happy_var_2 (SYMBOL Xor [] (nameFromString "^"))) happy_var_3
	)}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_184 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_184 = happySpecReduce_3  47# happyReduction_184
happyReduction_184 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { (HappyWrap57 happy_var_1) -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { (HappyWrap57 happy_var_3) -> 
	happyIn57
		 (binOp happy_var_1 happy_var_2 happy_var_3
	)}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_185 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_185 = happySpecReduce_3  47# happyReduction_185
happyReduction_185 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { (HappyWrap57 happy_var_1) -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { (HappyWrap57 happy_var_3) -> 
	happyIn57
		 (binOp happy_var_1 happy_var_2 happy_var_3
	)}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_186 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_186 = happySpecReduce_3  47# happyReduction_186
happyReduction_186 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { (HappyWrap57 happy_var_1) -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { (HappyWrap57 happy_var_3) -> 
	happyIn57
		 (binOp happy_var_1 happy_var_2 happy_var_3
	)}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_187 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_187 = happySpecReduce_3  47# happyReduction_187
happyReduction_187 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { (HappyWrap57 happy_var_1) -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { (HappyWrap57 happy_var_3) -> 
	happyIn57
		 (binOp happy_var_1 happy_var_2 happy_var_3
	)}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_188 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_188 = happySpecReduce_3  47# happyReduction_188
happyReduction_188 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { (HappyWrap57 happy_var_1) -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { (HappyWrap57 happy_var_3) -> 
	happyIn57
		 (binOp happy_var_1 happy_var_2 happy_var_3
	)}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_189 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_189 = happySpecReduce_3  47# happyReduction_189
happyReduction_189 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { (HappyWrap57 happy_var_1) -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { (HappyWrap57 happy_var_3) -> 
	happyIn57
		 (binOp happy_var_1 happy_var_2 happy_var_3
	)}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_190 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_190 = happySpecReduce_3  47# happyReduction_190
happyReduction_190 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { (HappyWrap57 happy_var_1) -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { (HappyWrap57 happy_var_3) -> 
	happyIn57
		 (binOp happy_var_1 happy_var_2 happy_var_3
	)}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_191 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_191 = happySpecReduce_3  47# happyReduction_191
happyReduction_191 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { (HappyWrap57 happy_var_1) -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { (HappyWrap57 happy_var_3) -> 
	happyIn57
		 (binOp happy_var_1 happy_var_2 happy_var_3
	)}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_192 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_192 = happySpecReduce_3  47# happyReduction_192
happyReduction_192 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { (HappyWrap57 happy_var_1) -> 
	case happyOutTok happy_x_2 of { (L happy_var_2 LTH) -> 
	case happyOut57 happy_x_3 of { (HappyWrap57 happy_var_3) -> 
	happyIn57
		 (binOp happy_var_1 (L happy_var_2 (SYMBOL Less [] (nameFromString "<"))) happy_var_3
	)}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_193 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_193 = happyReduce 5# 47# happyReduction_193
happyReduction_193 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut57 happy_x_1 of { (HappyWrap57 happy_var_1) -> 
	case happyOut55 happy_x_3 of { (HappyWrap55 happy_var_3) -> 
	case happyOut57 happy_x_5 of { (HappyWrap57 happy_var_5) -> 
	happyIn57
		 (AppExp (BinOp happy_var_3 NoInfo (happy_var_1, NoInfo) (happy_var_5, NoInfo) (srcspan happy_var_1 happy_var_5)) NoInfo
	) `HappyStk` happyRest}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_194 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_194 = happySpecReduce_3  47# happyReduction_194
happyReduction_194 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { (HappyWrap57 happy_var_1) -> 
	case happyOut57 happy_x_3 of { (HappyWrap57 happy_var_3) -> 
	happyIn57
		 (AppExp (Range happy_var_1 Nothing (ToInclusive happy_var_3) (srcspan happy_var_1 happy_var_3)) NoInfo
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_195 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_195 = happySpecReduce_3  47# happyReduction_195
happyReduction_195 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { (HappyWrap57 happy_var_1) -> 
	case happyOut57 happy_x_3 of { (HappyWrap57 happy_var_3) -> 
	happyIn57
		 (AppExp (Range happy_var_1 Nothing (UpToExclusive happy_var_3) (srcspan happy_var_1 happy_var_3)) NoInfo
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_196 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_196 = happySpecReduce_3  47# happyReduction_196
happyReduction_196 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { (HappyWrap57 happy_var_1) -> 
	case happyOut57 happy_x_3 of { (HappyWrap57 happy_var_3) -> 
	happyIn57
		 (AppExp (Range happy_var_1 Nothing (DownToExclusive happy_var_3)  (srcspan happy_var_1 happy_var_3)) NoInfo
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_197 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_197 = happyReduce 5# 47# happyReduction_197
happyReduction_197 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut57 happy_x_1 of { (HappyWrap57 happy_var_1) -> 
	case happyOut57 happy_x_3 of { (HappyWrap57 happy_var_3) -> 
	case happyOut57 happy_x_5 of { (HappyWrap57 happy_var_5) -> 
	happyIn57
		 (AppExp (Range happy_var_1 (Just happy_var_3) (ToInclusive happy_var_5) (srcspan happy_var_1 happy_var_5)) NoInfo
	) `HappyStk` happyRest}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_198 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_198 = happyReduce 5# 47# happyReduction_198
happyReduction_198 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut57 happy_x_1 of { (HappyWrap57 happy_var_1) -> 
	case happyOut57 happy_x_3 of { (HappyWrap57 happy_var_3) -> 
	case happyOut57 happy_x_5 of { (HappyWrap57 happy_var_5) -> 
	happyIn57
		 (AppExp (Range happy_var_1 (Just happy_var_3) (UpToExclusive happy_var_5) (srcspan happy_var_1 happy_var_5)) NoInfo
	) `HappyStk` happyRest}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_199 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_199 = happyReduce 5# 47# happyReduction_199
happyReduction_199 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut57 happy_x_1 of { (HappyWrap57 happy_var_1) -> 
	case happyOut57 happy_x_3 of { (HappyWrap57 happy_var_3) -> 
	case happyOut57 happy_x_5 of { (HappyWrap57 happy_var_5) -> 
	happyIn57
		 (AppExp (Range happy_var_1 (Just happy_var_3) (DownToExclusive happy_var_5) (srcspan happy_var_1 happy_var_5)) NoInfo
	) `HappyStk` happyRest}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_200 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_200 = happyMonadReduce 3# 47# happyReduction_200
happyReduction_200 (happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest) tk
	 = happyThen ((case happyOutTok happy_x_2 of { (L happy_var_2 TWO_DOTS) -> 
	( twoDotsRange happy_var_2)})
	) (\r -> happyReturn (happyIn57 r))

#if __GLASGOW_HASKELL__ >= 710
happyReduce_201 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_201 = happyMonadReduce 3# 47# happyReduction_201
happyReduction_201 (happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest) tk
	 = happyThen ((case happyOutTok happy_x_2 of { (L happy_var_2 TWO_DOTS) -> 
	( twoDotsRange happy_var_2)})
	) (\r -> happyReturn (happyIn57 r))

#if __GLASGOW_HASKELL__ >= 710
happyReduce_202 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_202 = happySpecReduce_2  47# happyReduction_202
happyReduction_202 happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { (L happy_var_1 NEGATE) -> 
	case happyOut57 happy_x_2 of { (HappyWrap57 happy_var_2) -> 
	happyIn57
		 (Negate happy_var_2 happy_var_1
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_203 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_203 = happySpecReduce_2  47# happyReduction_203
happyReduction_203 happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { (L happy_var_1 BANG) -> 
	case happyOut57 happy_x_2 of { (HappyWrap57 happy_var_2) -> 
	happyIn57
		 (Not happy_var_2 happy_var_1
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_204 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_204 = happyReduce 7# 47# happyReduction_204
happyReduction_204 (happy_x_7 `HappyStk`
	happy_x_6 `HappyStk`
	happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut57 happy_x_1 of { (HappyWrap57 happy_var_1) -> 
	case happyOut88 happy_x_4 of { (HappyWrap88 happy_var_4) -> 
	case happyOut57 happy_x_7 of { (HappyWrap57 happy_var_7) -> 
	happyIn57
		 (Update happy_var_1 happy_var_4 happy_var_7 (srcspan happy_var_1 happy_var_7)
	) `HappyStk` happyRest}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_205 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_205 = happyReduce 5# 47# happyReduction_205
happyReduction_205 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut57 happy_x_1 of { (HappyWrap57 happy_var_1) -> 
	case happyOut67 happy_x_3 of { (HappyWrap67 happy_var_3) -> 
	case happyOut57 happy_x_5 of { (HappyWrap57 happy_var_5) -> 
	happyIn57
		 (RecordUpdate happy_var_1 (map fst happy_var_3) happy_var_5 NoInfo (srcspan happy_var_1 happy_var_5)
	) `HappyStk` happyRest}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_206 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_206 = happyReduce 5# 47# happyReduction_206
happyReduction_206 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { (L happy_var_1 BACKSLASH) -> 
	case happyOut53 happy_x_2 of { (HappyWrap53 happy_var_2) -> 
	case happyOut118 happy_x_3 of { happy_var_3 -> 
	case happyOut56 happy_x_5 of { (HappyWrap56 happy_var_5) -> 
	happyIn57
		 (Lambda (fst happy_var_2 : snd happy_var_2) happy_var_5 happy_var_3 NoInfo (srcspan happy_var_1 happy_var_5)
	) `HappyStk` happyRest}}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_207 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_207 = happySpecReduce_1  47# happyReduction_207
happyReduction_207 happy_x_1
	 =  case happyOut58 happy_x_1 of { (HappyWrap58 happy_var_1) -> 
	happyIn57
		 (happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_208 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_208 = happyMonadReduce 1# 48# happyReduction_208
happyReduction_208 (happy_x_1 `HappyStk`
	happyRest) tk
	 = happyThen ((case happyOut59 happy_x_1 of { (HappyWrap59 happy_var_1) -> 
	( applyExp happy_var_1)})
	) (\r -> happyReturn (happyIn58 r))

#if __GLASGOW_HASKELL__ >= 710
happyReduce_209 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_209 = happySpecReduce_2  49# happyReduction_209
happyReduction_209 happy_x_2
	happy_x_1
	 =  case happyOut59 happy_x_1 of { (HappyWrap59 happy_var_1) -> 
	case happyOut60 happy_x_2 of { (HappyWrap60 happy_var_2) -> 
	happyIn59
		 (happy_var_1 ++ [happy_var_2]
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_210 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_210 = happySpecReduce_1  49# happyReduction_210
happyReduction_210 happy_x_1
	 =  case happyOut60 happy_x_1 of { (HappyWrap60 happy_var_1) -> 
	happyIn59
		 ([happy_var_1]
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_211 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_211 = happySpecReduce_1  50# happyReduction_211
happyReduction_211 happy_x_1
	 =  case happyOut62 happy_x_1 of { (HappyWrap62 happy_var_1) -> 
	happyIn60
		 (Literal (fst happy_var_1) (snd happy_var_1)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_212 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_212 = happySpecReduce_1  50# happyReduction_212
happyReduction_212 happy_x_1
	 =  case happyOut46 happy_x_1 of { (HappyWrap46 happy_var_1) -> 
	happyIn60
		 (Constr (fst happy_var_1) [] NoInfo (snd happy_var_1)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_213 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_213 = happySpecReduce_1  50# happyReduction_213
happyReduction_213 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn60
		 (let L loc (CHARLIT x) = happy_var_1
                        in IntLit (toInteger (ord x)) NoInfo loc
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_214 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_214 = happySpecReduce_1  50# happyReduction_214
happyReduction_214 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn60
		 (let L loc (INTLIT x) = happy_var_1 in IntLit x NoInfo loc
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_215 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_215 = happySpecReduce_1  50# happyReduction_215
happyReduction_215 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn60
		 (let L loc (FLOATLIT x) = happy_var_1 in FloatLit x NoInfo loc
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_216 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_216 = happySpecReduce_1  50# happyReduction_216
happyReduction_216 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn60
		 (let L loc (STRINGLIT s) = happy_var_1 in
                        StringLit (BS.unpack (T.encodeUtf8 s)) loc
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_217 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_217 = happyReduce 4# 50# happyReduction_217
happyReduction_217 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { (L happy_var_1 LPAR) -> 
	case happyOut56 happy_x_2 of { (HappyWrap56 happy_var_2) -> 
	case happyOutTok happy_x_3 of { (L happy_var_3 RPAR) -> 
	case happyOut66 happy_x_4 of { (HappyWrap66 happy_var_4) -> 
	happyIn60
		 (foldl (\x (y, _) -> Project y x NoInfo (srclocOf x))
               (Parens happy_var_2 (srcspan happy_var_1 (happy_var_3:map snd happy_var_4)))
               happy_var_4
	) `HappyStk` happyRest}}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_218 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_218 = happyReduce 5# 50# happyReduction_218
happyReduction_218 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { (L happy_var_1 LPAR) -> 
	case happyOut56 happy_x_2 of { (HappyWrap56 happy_var_2) -> 
	case happyOut88 happy_x_4 of { (HappyWrap88 happy_var_4) -> 
	case happyOutTok happy_x_5 of { (L happy_var_5 RBRACKET) -> 
	happyIn60
		 (AppExp (Index (Parens happy_var_2 happy_var_1) happy_var_4 (srcspan happy_var_1 happy_var_5)) NoInfo
	) `HappyStk` happyRest}}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_219 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_219 = happyReduce 5# 50# happyReduction_219
happyReduction_219 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { (L happy_var_1 LPAR) -> 
	case happyOut56 happy_x_2 of { (HappyWrap56 happy_var_2) -> 
	case happyOut63 happy_x_4 of { (HappyWrap63 happy_var_4) -> 
	case happyOutTok happy_x_5 of { (L happy_var_5 RPAR) -> 
	happyIn60
		 (TupLit (happy_var_2 : fst happy_var_4 : snd happy_var_4) (srcspan happy_var_1 happy_var_5)
	) `HappyStk` happyRest}}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_220 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_220 = happySpecReduce_2  50# happyReduction_220
happyReduction_220 happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { (L happy_var_1 LPAR) -> 
	case happyOutTok happy_x_2 of { (L happy_var_2 RPAR) -> 
	happyIn60
		 (TupLit [] (srcspan happy_var_1 happy_var_2)
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_221 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_221 = happySpecReduce_3  50# happyReduction_221
happyReduction_221 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { (L happy_var_1 LBRACKET) -> 
	case happyOut63 happy_x_2 of { (HappyWrap63 happy_var_2) -> 
	case happyOutTok happy_x_3 of { (L happy_var_3 RBRACKET) -> 
	happyIn60
		 (ArrayLit (fst happy_var_2:snd happy_var_2) NoInfo (srcspan happy_var_1 happy_var_3)
	)}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_222 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_222 = happySpecReduce_2  50# happyReduction_222
happyReduction_222 happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { (L happy_var_1 LBRACKET) -> 
	case happyOutTok happy_x_2 of { (L happy_var_2 RBRACKET) -> 
	happyIn60
		 (ArrayLit [] NoInfo (srcspan happy_var_1 happy_var_2)
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_223 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_223 = happySpecReduce_2  50# happyReduction_223
happyReduction_223 happy_x_2
	happy_x_1
	 =  case happyOut86 happy_x_1 of { (HappyWrap86 happy_var_1) -> 
	case happyOut66 happy_x_2 of { (HappyWrap66 happy_var_2) -> 
	happyIn60
		 (let ((v, vloc),slice,loc) = happy_var_1
         in foldl (\x (y, _) -> Project y x NoInfo (srcspan x (srclocOf x)))
                  (AppExp (Index (Var v NoInfo vloc) slice (srcspan vloc loc)) NoInfo)
                  happy_var_2
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_224 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_224 = happySpecReduce_1  50# happyReduction_224
happyReduction_224 happy_x_1
	 =  case happyOut55 happy_x_1 of { (HappyWrap55 happy_var_1) -> 
	happyIn60
		 (Var (fst happy_var_1) NoInfo (snd happy_var_1)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_225 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_225 = happySpecReduce_3  50# happyReduction_225
happyReduction_225 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { (L happy_var_1 LCURLY) -> 
	case happyOut69 happy_x_2 of { (HappyWrap69 happy_var_2) -> 
	case happyOutTok happy_x_3 of { (L happy_var_3 RCURLY) -> 
	happyIn60
		 (RecordLit happy_var_2 (srcspan happy_var_1 happy_var_3)
	)}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_226 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_226 = happySpecReduce_3  50# happyReduction_226
happyReduction_226 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut56 happy_x_2 of { (HappyWrap56 happy_var_2) -> 
	case happyOutTok happy_x_3 of { (L happy_var_3 RPAR) -> 
	happyIn60
		 (let L loc (QUALPAREN qs name) = happy_var_1 in
         QualParens (QualName qs name, loc) happy_var_2 (srcspan happy_var_1 happy_var_3)
	)}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_227 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_227 = happySpecReduce_3  50# happyReduction_227
happyReduction_227 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { (L happy_var_1 LPAR) -> 
	case happyOutTok happy_x_3 of { (L happy_var_3 RPAR) -> 
	happyIn60
		 (OpSection (qualName (nameFromString "-")) NoInfo (srcspan happy_var_1 happy_var_3)
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_228 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_228 = happyReduce 4# 50# happyReduction_228
happyReduction_228 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { (L happy_var_1 LPAR) -> 
	case happyOut57 happy_x_2 of { (HappyWrap57 happy_var_2) -> 
	case happyOutTok happy_x_4 of { (L happy_var_4 RPAR) -> 
	happyIn60
		 (OpSectionLeft (qualName (nameFromString "-"))
         NoInfo happy_var_2 (NoInfo, NoInfo) (NoInfo, NoInfo) (srcspan happy_var_1 happy_var_4)
	) `HappyStk` happyRest}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_229 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_229 = happyReduce 4# 50# happyReduction_229
happyReduction_229 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { (L happy_var_1 LPAR) -> 
	case happyOut32 happy_x_2 of { (HappyWrap32 happy_var_2) -> 
	case happyOut57 happy_x_3 of { (HappyWrap57 happy_var_3) -> 
	case happyOutTok happy_x_4 of { (L happy_var_4 RPAR) -> 
	happyIn60
		 (OpSectionRight (fst happy_var_2) NoInfo happy_var_3 (NoInfo, NoInfo) NoInfo (srcspan happy_var_1 happy_var_4)
	) `HappyStk` happyRest}}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_230 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_230 = happyReduce 4# 50# happyReduction_230
happyReduction_230 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { (L happy_var_1 LPAR) -> 
	case happyOut57 happy_x_2 of { (HappyWrap57 happy_var_2) -> 
	case happyOut32 happy_x_3 of { (HappyWrap32 happy_var_3) -> 
	case happyOutTok happy_x_4 of { (L happy_var_4 RPAR) -> 
	happyIn60
		 (OpSectionLeft (fst happy_var_3) NoInfo happy_var_2 (NoInfo, NoInfo) (NoInfo, NoInfo) (srcspan happy_var_1 happy_var_4)
	) `HappyStk` happyRest}}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_231 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_231 = happySpecReduce_3  50# happyReduction_231
happyReduction_231 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { (L happy_var_1 LPAR) -> 
	case happyOut32 happy_x_2 of { (HappyWrap32 happy_var_2) -> 
	case happyOutTok happy_x_3 of { (L happy_var_3 RPAR) -> 
	happyIn60
		 (OpSection (fst happy_var_2) NoInfo (srcspan happy_var_1 happy_var_3)
	)}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_232 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_232 = happyReduce 4# 50# happyReduction_232
happyReduction_232 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { (L happy_var_1 LPAR) -> 
	case happyOut65 happy_x_2 of { (HappyWrap65 happy_var_2) -> 
	case happyOut66 happy_x_3 of { (HappyWrap66 happy_var_3) -> 
	case happyOutTok happy_x_4 of { (L happy_var_4 RPAR) -> 
	happyIn60
		 (ProjectSection (map fst (happy_var_2:happy_var_3)) NoInfo (srcspan happy_var_1 happy_var_4)
	) `HappyStk` happyRest}}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_233 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_233 = happyReduce 6# 50# happyReduction_233
happyReduction_233 (happy_x_6 `HappyStk`
	happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { (L happy_var_1 LPAR) -> 
	case happyOut88 happy_x_4 of { (HappyWrap88 happy_var_4) -> 
	case happyOutTok happy_x_6 of { (L happy_var_6 RPAR) -> 
	happyIn60
		 (IndexSection happy_var_4 NoInfo (srcspan happy_var_1 happy_var_6)
	) `HappyStk` happyRest}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_234 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_234 = happySpecReduce_1  51# happyReduction_234
happyReduction_234 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn61
		 (let L loc (I8LIT num)  = happy_var_1 in (SignedValue $ Int8Value num, loc)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_235 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_235 = happySpecReduce_1  51# happyReduction_235
happyReduction_235 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn61
		 (let L loc (I16LIT num) = happy_var_1 in (SignedValue $ Int16Value num, loc)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_236 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_236 = happySpecReduce_1  51# happyReduction_236
happyReduction_236 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn61
		 (let L loc (I32LIT num) = happy_var_1 in (SignedValue $ Int32Value num, loc)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_237 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_237 = happySpecReduce_1  51# happyReduction_237
happyReduction_237 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn61
		 (let L loc (I64LIT num) = happy_var_1 in (SignedValue $ Int64Value num, loc)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_238 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_238 = happySpecReduce_1  51# happyReduction_238
happyReduction_238 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn61
		 (let L loc (U8LIT num)  = happy_var_1 in (UnsignedValue $ Int8Value $ fromIntegral num, loc)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_239 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_239 = happySpecReduce_1  51# happyReduction_239
happyReduction_239 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn61
		 (let L loc (U16LIT num) = happy_var_1 in (UnsignedValue $ Int16Value $ fromIntegral num, loc)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_240 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_240 = happySpecReduce_1  51# happyReduction_240
happyReduction_240 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn61
		 (let L loc (U32LIT num) = happy_var_1 in (UnsignedValue $ Int32Value $ fromIntegral num, loc)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_241 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_241 = happySpecReduce_1  51# happyReduction_241
happyReduction_241 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn61
		 (let L loc (U64LIT num) = happy_var_1 in (UnsignedValue $ Int64Value $ fromIntegral num, loc)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_242 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_242 = happySpecReduce_1  51# happyReduction_242
happyReduction_242 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn61
		 (let L loc (F16LIT num) = happy_var_1 in (FloatValue $ Float16Value num, loc)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_243 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_243 = happySpecReduce_1  51# happyReduction_243
happyReduction_243 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn61
		 (let L loc (F32LIT num) = happy_var_1 in (FloatValue $ Float32Value num, loc)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_244 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_244 = happySpecReduce_1  51# happyReduction_244
happyReduction_244 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn61
		 (let L loc (F64LIT num) = happy_var_1 in (FloatValue $ Float64Value num, loc)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_245 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_245 = happySpecReduce_1  52# happyReduction_245
happyReduction_245 happy_x_1
	 =  case happyOutTok happy_x_1 of { (L happy_var_1 TRUE) -> 
	happyIn62
		 ((BoolValue True, happy_var_1)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_246 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_246 = happySpecReduce_1  52# happyReduction_246
happyReduction_246 happy_x_1
	 =  case happyOutTok happy_x_1 of { (L happy_var_1 FALSE) -> 
	happyIn62
		 ((BoolValue False, happy_var_1)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_247 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_247 = happySpecReduce_1  52# happyReduction_247
happyReduction_247 happy_x_1
	 =  case happyOut61 happy_x_1 of { (HappyWrap61 happy_var_1) -> 
	happyIn62
		 (happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_248 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_248 = happySpecReduce_1  53# happyReduction_248
happyReduction_248 happy_x_1
	 =  case happyOut64 happy_x_1 of { (HappyWrap64 happy_var_1) -> 
	happyIn63
		 (case reverse (snd happy_var_1 : fst happy_var_1) of
                    []   -> (snd happy_var_1, [])
                    y:ys -> (y, ys)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_249 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_249 = happySpecReduce_3  54# happyReduction_249
happyReduction_249 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut64 happy_x_1 of { (HappyWrap64 happy_var_1) -> 
	case happyOut56 happy_x_3 of { (HappyWrap56 happy_var_3) -> 
	happyIn64
		 ((snd happy_var_1 : fst happy_var_1, happy_var_3)
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_250 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_250 = happySpecReduce_1  54# happyReduction_250
happyReduction_250 happy_x_1
	 =  case happyOut56 happy_x_1 of { (HappyWrap56 happy_var_1) -> 
	happyIn64
		 (([], happy_var_1)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_251 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_251 = happySpecReduce_2  55# happyReduction_251
happyReduction_251 happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_2 of { happy_var_2 -> 
	happyIn65
		 (let L loc (ID f) = happy_var_2 in (f, loc)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_252 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_252 = happySpecReduce_1  55# happyReduction_252
happyReduction_252 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn65
		 (let L loc (PROJ_INTFIELD x) = happy_var_1 in (x, loc)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_253 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_253 = happySpecReduce_2  56# happyReduction_253
happyReduction_253 happy_x_2
	happy_x_1
	 =  case happyOut65 happy_x_1 of { (HappyWrap65 happy_var_1) -> 
	case happyOut66 happy_x_2 of { (HappyWrap66 happy_var_2) -> 
	happyIn66
		 (happy_var_1 : happy_var_2
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_254 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_254 = happySpecReduce_0  56# happyReduction_254
happyReduction_254  =  happyIn66
		 ([]
	)

#if __GLASGOW_HASKELL__ >= 710
happyReduce_255 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_255 = happySpecReduce_2  57# happyReduction_255
happyReduction_255 happy_x_2
	happy_x_1
	 =  case happyOut91 happy_x_1 of { (HappyWrap91 happy_var_1) -> 
	case happyOut66 happy_x_2 of { (HappyWrap66 happy_var_2) -> 
	happyIn67
		 ((fst happy_var_1, snd happy_var_1) : happy_var_2
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_256 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_256 = happySpecReduce_3  58# happyReduction_256
happyReduction_256 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut91 happy_x_1 of { (HappyWrap91 happy_var_1) -> 
	case happyOut56 happy_x_3 of { (HappyWrap56 happy_var_3) -> 
	happyIn68
		 (RecordFieldExplicit (fst happy_var_1) happy_var_3 (srcspan (snd happy_var_1) happy_var_3)
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_257 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_257 = happySpecReduce_1  58# happyReduction_257
happyReduction_257 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn68
		 (let L loc (ID s) = happy_var_1 in RecordFieldImplicit s NoInfo loc
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_258 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_258 = happySpecReduce_1  59# happyReduction_258
happyReduction_258 happy_x_1
	 =  case happyOut70 happy_x_1 of { (HappyWrap70 happy_var_1) -> 
	happyIn69
		 (happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_259 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_259 = happySpecReduce_0  59# happyReduction_259
happyReduction_259  =  happyIn69
		 ([]
	)

#if __GLASGOW_HASKELL__ >= 710
happyReduce_260 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_260 = happySpecReduce_3  60# happyReduction_260
happyReduction_260 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut68 happy_x_1 of { (HappyWrap68 happy_var_1) -> 
	case happyOut70 happy_x_3 of { (HappyWrap70 happy_var_3) -> 
	happyIn70
		 (happy_var_1 : happy_var_3
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_261 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_261 = happySpecReduce_1  60# happyReduction_261
happyReduction_261 happy_x_1
	 =  case happyOut68 happy_x_1 of { (HappyWrap68 happy_var_1) -> 
	happyIn70
		 ([happy_var_1]
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_262 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_262 = happyReduce 6# 61# happyReduction_262
happyReduction_262 (happy_x_6 `HappyStk`
	happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { (L happy_var_1 LET) -> 
	case happyOut29 happy_x_2 of { (HappyWrap29 happy_var_2) -> 
	case happyOut92 happy_x_3 of { (HappyWrap92 happy_var_3) -> 
	case happyOut56 happy_x_5 of { (HappyWrap56 happy_var_5) -> 
	case happyOut72 happy_x_6 of { (HappyWrap72 happy_var_6) -> 
	happyIn71
		 (AppExp (LetPat happy_var_2 happy_var_3 happy_var_5 happy_var_6 (srcspan happy_var_1 happy_var_6)) NoInfo
	) `HappyStk` happyRest}}}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_263 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_263 = happyReduce 5# 61# happyReduction_263
happyReduction_263 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { (L happy_var_1 LET) -> 
	case happyOut92 happy_x_2 of { (HappyWrap92 happy_var_2) -> 
	case happyOut56 happy_x_4 of { (HappyWrap56 happy_var_4) -> 
	case happyOut72 happy_x_5 of { (HappyWrap72 happy_var_5) -> 
	happyIn71
		 (AppExp (LetPat [] happy_var_2 happy_var_4 happy_var_5 (srcspan happy_var_1 happy_var_5)) NoInfo
	) `HappyStk` happyRest}}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_264 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_264 = happyReduce 8# 61# happyReduction_264
happyReduction_264 (happy_x_8 `HappyStk`
	happy_x_7 `HappyStk`
	happy_x_6 `HappyStk`
	happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { (L happy_var_1 LET) -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut31 happy_x_3 of { (HappyWrap31 happy_var_3) -> 
	case happyOut53 happy_x_4 of { (HappyWrap53 happy_var_4) -> 
	case happyOut117 happy_x_5 of { happy_var_5 -> 
	case happyOut56 happy_x_7 of { (HappyWrap56 happy_var_7) -> 
	case happyOut72 happy_x_8 of { (HappyWrap72 happy_var_8) -> 
	happyIn71
		 (let L _ (ID name) = happy_var_2
         in AppExp (LetFun name (happy_var_3, fst happy_var_4 : snd happy_var_4, (fmap declaredType happy_var_5), NoInfo, happy_var_7)
                    happy_var_8 (srcspan happy_var_1 happy_var_8))
                   NoInfo
	) `HappyStk` happyRest}}}}}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_265 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_265 = happyReduce 5# 61# happyReduction_265
happyReduction_265 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { (L happy_var_1 LET) -> 
	case happyOut85 happy_x_2 of { (HappyWrap85 happy_var_2) -> 
	case happyOut56 happy_x_4 of { (HappyWrap56 happy_var_4) -> 
	case happyOut72 happy_x_5 of { (HappyWrap72 happy_var_5) -> 
	happyIn71
		 (let ((v,_),slice,loc) = happy_var_2; ident = Ident v NoInfo loc
         in AppExp (LetWith ident ident slice happy_var_4 happy_var_5 (srcspan happy_var_1 happy_var_5)) NoInfo
	) `HappyStk` happyRest}}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_266 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_266 = happySpecReduce_2  62# happyReduction_266
happyReduction_266 happy_x_2
	happy_x_1
	 =  case happyOut56 happy_x_2 of { (HappyWrap56 happy_var_2) -> 
	happyIn72
		 (happy_var_2
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_267 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_267 = happySpecReduce_1  62# happyReduction_267
happyReduction_267 happy_x_1
	 =  case happyOut71 happy_x_1 of { (HappyWrap71 happy_var_1) -> 
	happyIn72
		 (happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_268 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_268 = happyMonadReduce 1# 62# happyReduction_268
happyReduction_268 (happy_x_1 `HappyStk`
	happyRest) tk
	 = happyThen ((case happyOutTok happy_x_1 of { (L happy_var_1 DEF) -> 
	( parseErrorAt happy_var_1 (Just "Unexpected \"def\" - missing \"in\"?"))})
	) (\r -> happyReturn (happyIn72 r))

#if __GLASGOW_HASKELL__ >= 710
happyReduce_269 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_269 = happyMonadReduce 1# 62# happyReduction_269
happyReduction_269 (happy_x_1 `HappyStk`
	happyRest) tk
	 = happyThen ((case happyOutTok happy_x_1 of { (L happy_var_1 TYPE) -> 
	( parseErrorAt happy_var_1 (Just "Unexpected \"type\" - missing \"in\"?"))})
	) (\r -> happyReturn (happyIn72 r))

#if __GLASGOW_HASKELL__ >= 710
happyReduce_270 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_270 = happyMonadReduce 1# 62# happyReduction_270
happyReduction_270 (happy_x_1 `HappyStk`
	happyRest) tk
	 = happyThen ((case happyOutTok happy_x_1 of { (L happy_var_1 MODULE) -> 
	( parseErrorAt happy_var_1 (Just "Unexpected \"module\" - missing \"in\"?"))})
	) (\r -> happyReturn (happyIn72 r))

#if __GLASGOW_HASKELL__ >= 710
happyReduce_271 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_271 = happySpecReduce_3  63# happyReduction_271
happyReduction_271 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { (L happy_var_1 MATCH) -> 
	case happyOut56 happy_x_2 of { (HappyWrap56 happy_var_2) -> 
	case happyOut74 happy_x_3 of { (HappyWrap74 happy_var_3) -> 
	happyIn73
		 (let loc = srcspan happy_var_1 (NE.toList happy_var_3)
              in AppExp (Match happy_var_2 happy_var_3 loc) NoInfo
	)}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_272 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_272 = happySpecReduce_1  64# happyReduction_272
happyReduction_272 happy_x_1
	 =  case happyOut75 happy_x_1 of { (HappyWrap75 happy_var_1) -> 
	happyIn74
		 (happy_var_1 NE.:| []
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_273 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_273 = happySpecReduce_2  64# happyReduction_273
happyReduction_273 happy_x_2
	happy_x_1
	 =  case happyOut75 happy_x_1 of { (HappyWrap75 happy_var_1) -> 
	case happyOut74 happy_x_2 of { (HappyWrap74 happy_var_2) -> 
	happyIn74
		 (NE.cons happy_var_1 happy_var_2
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_274 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_274 = happyReduce 4# 65# happyReduction_274
happyReduction_274 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { (L happy_var_1 CASE) -> 
	case happyOut76 happy_x_2 of { (HappyWrap76 happy_var_2) -> 
	case happyOut56 happy_x_4 of { (HappyWrap56 happy_var_4) -> 
	happyIn75
		 (let loc = srcspan happy_var_1 happy_var_4 in CasePat happy_var_2 happy_var_4 loc
	) `HappyStk` happyRest}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_275 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_275 = happyReduce 4# 66# happyReduction_275
happyReduction_275 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { (L happy_var_1 HASH_LBRACKET) -> 
	case happyOut99 happy_x_2 of { (HappyWrap99 happy_var_2) -> 
	case happyOut76 happy_x_4 of { (HappyWrap76 happy_var_4) -> 
	happyIn76
		 (PatAttr happy_var_2 happy_var_4 (srcspan happy_var_1 happy_var_4)
	) `HappyStk` happyRest}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_276 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_276 = happySpecReduce_3  66# happyReduction_276
happyReduction_276 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut78 happy_x_1 of { (HappyWrap78 happy_var_1) -> 
	case happyOut36 happy_x_3 of { (HappyWrap36 happy_var_3) -> 
	happyIn76
		 (PatAscription happy_var_1 happy_var_3 (srcspan happy_var_1 happy_var_3)
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_277 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_277 = happySpecReduce_1  66# happyReduction_277
happyReduction_277 happy_x_1
	 =  case happyOut78 happy_x_1 of { (HappyWrap78 happy_var_1) -> 
	happyIn76
		 (happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_278 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_278 = happySpecReduce_2  66# happyReduction_278
happyReduction_278 happy_x_2
	happy_x_1
	 =  case happyOut46 happy_x_1 of { (HappyWrap46 happy_var_1) -> 
	case happyOut79 happy_x_2 of { (HappyWrap79 happy_var_2) -> 
	happyIn76
		 (let (n, loc) = happy_var_1;
                                            loc' = srcspan loc happy_var_2
                                        in PatConstr n NoInfo happy_var_2 loc'
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_279 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_279 = happySpecReduce_1  67# happyReduction_279
happyReduction_279 happy_x_1
	 =  case happyOut76 happy_x_1 of { (HappyWrap76 happy_var_1) -> 
	happyIn77
		 ([happy_var_1]
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_280 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_280 = happySpecReduce_3  67# happyReduction_280
happyReduction_280 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut76 happy_x_1 of { (HappyWrap76 happy_var_1) -> 
	case happyOut77 happy_x_3 of { (HappyWrap77 happy_var_3) -> 
	happyIn77
		 (happy_var_1 : happy_var_3
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_281 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_281 = happySpecReduce_1  68# happyReduction_281
happyReduction_281 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn78
		 (let L loc (ID name) = happy_var_1 in Id name NoInfo loc
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_282 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_282 = happySpecReduce_3  68# happyReduction_282
happyReduction_282 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { (L happy_var_1 LPAR) -> 
	case happyOut33 happy_x_2 of { (HappyWrap33 happy_var_2) -> 
	case happyOutTok happy_x_3 of { (L happy_var_3 RPAR) -> 
	happyIn78
		 (Id happy_var_2 NoInfo (srcspan happy_var_1 happy_var_3)
	)}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_283 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_283 = happySpecReduce_1  68# happyReduction_283
happyReduction_283 happy_x_1
	 =  case happyOutTok happy_x_1 of { (L happy_var_1 UNDERSCORE) -> 
	happyIn78
		 (Wildcard NoInfo happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_284 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_284 = happySpecReduce_2  68# happyReduction_284
happyReduction_284 happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { (L happy_var_1 LPAR) -> 
	case happyOutTok happy_x_2 of { (L happy_var_2 RPAR) -> 
	happyIn78
		 (TuplePat [] (srcspan happy_var_1 happy_var_2)
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_285 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_285 = happySpecReduce_3  68# happyReduction_285
happyReduction_285 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { (L happy_var_1 LPAR) -> 
	case happyOut76 happy_x_2 of { (HappyWrap76 happy_var_2) -> 
	case happyOutTok happy_x_3 of { (L happy_var_3 RPAR) -> 
	happyIn78
		 (PatParens happy_var_2 (srcspan happy_var_1 happy_var_3)
	)}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_286 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_286 = happyReduce 5# 68# happyReduction_286
happyReduction_286 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { (L happy_var_1 LPAR) -> 
	case happyOut76 happy_x_2 of { (HappyWrap76 happy_var_2) -> 
	case happyOut77 happy_x_4 of { (HappyWrap77 happy_var_4) -> 
	case happyOutTok happy_x_5 of { (L happy_var_5 RPAR) -> 
	happyIn78
		 (TuplePat (happy_var_2:happy_var_4) (srcspan happy_var_1 happy_var_5)
	) `HappyStk` happyRest}}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_287 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_287 = happySpecReduce_3  68# happyReduction_287
happyReduction_287 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { (L happy_var_1 LCURLY) -> 
	case happyOut81 happy_x_2 of { (HappyWrap81 happy_var_2) -> 
	case happyOutTok happy_x_3 of { (L happy_var_3 RCURLY) -> 
	happyIn78
		 (RecordPat happy_var_2 (srcspan happy_var_1 happy_var_3)
	)}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_288 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_288 = happySpecReduce_1  68# happyReduction_288
happyReduction_288 happy_x_1
	 =  case happyOut83 happy_x_1 of { (HappyWrap83 happy_var_1) -> 
	happyIn78
		 (PatLit (fst happy_var_1) NoInfo (snd happy_var_1)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_289 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_289 = happySpecReduce_1  68# happyReduction_289
happyReduction_289 happy_x_1
	 =  case happyOut46 happy_x_1 of { (HappyWrap46 happy_var_1) -> 
	happyIn78
		 (let (n, loc) = happy_var_1
                                                      in PatConstr n NoInfo [] loc
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_290 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_290 = happySpecReduce_1  69# happyReduction_290
happyReduction_290 happy_x_1
	 =  case happyOut78 happy_x_1 of { (HappyWrap78 happy_var_1) -> 
	happyIn79
		 ([happy_var_1]
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_291 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_291 = happySpecReduce_2  69# happyReduction_291
happyReduction_291 happy_x_2
	happy_x_1
	 =  case happyOut79 happy_x_1 of { (HappyWrap79 happy_var_1) -> 
	case happyOut78 happy_x_2 of { (HappyWrap78 happy_var_2) -> 
	happyIn79
		 (happy_var_1 ++ [happy_var_2]
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_292 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_292 = happySpecReduce_3  70# happyReduction_292
happyReduction_292 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut91 happy_x_1 of { (HappyWrap91 happy_var_1) -> 
	case happyOut76 happy_x_3 of { (HappyWrap76 happy_var_3) -> 
	happyIn80
		 ((fst happy_var_1, happy_var_3)
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_293 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_293 = happySpecReduce_3  70# happyReduction_293
happyReduction_293 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut91 happy_x_1 of { (HappyWrap91 happy_var_1) -> 
	case happyOut36 happy_x_3 of { (HappyWrap36 happy_var_3) -> 
	happyIn80
		 ((fst happy_var_1, PatAscription (Id (fst happy_var_1) NoInfo (snd happy_var_1)) happy_var_3 (srcspan (snd happy_var_1) happy_var_3))
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_294 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_294 = happySpecReduce_1  70# happyReduction_294
happyReduction_294 happy_x_1
	 =  case happyOut91 happy_x_1 of { (HappyWrap91 happy_var_1) -> 
	happyIn80
		 ((fst happy_var_1, Id (fst happy_var_1) NoInfo (snd happy_var_1))
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_295 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_295 = happySpecReduce_1  71# happyReduction_295
happyReduction_295 happy_x_1
	 =  case happyOut82 happy_x_1 of { (HappyWrap82 happy_var_1) -> 
	happyIn81
		 (happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_296 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_296 = happySpecReduce_0  71# happyReduction_296
happyReduction_296  =  happyIn81
		 ([]
	)

#if __GLASGOW_HASKELL__ >= 710
happyReduce_297 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_297 = happySpecReduce_3  72# happyReduction_297
happyReduction_297 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut80 happy_x_1 of { (HappyWrap80 happy_var_1) -> 
	case happyOut82 happy_x_3 of { (HappyWrap82 happy_var_3) -> 
	happyIn82
		 (happy_var_1 : happy_var_3
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_298 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_298 = happySpecReduce_1  72# happyReduction_298
happyReduction_298 happy_x_1
	 =  case happyOut80 happy_x_1 of { (HappyWrap80 happy_var_1) -> 
	happyIn82
		 ([happy_var_1]
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_299 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_299 = happySpecReduce_1  73# happyReduction_299
happyReduction_299 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn83
		 (let L loc (CHARLIT x) = happy_var_1
                          in (PatLitInt (toInteger (ord x)), loc)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_300 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_300 = happySpecReduce_1  73# happyReduction_300
happyReduction_300 happy_x_1
	 =  case happyOut62 happy_x_1 of { (HappyWrap62 happy_var_1) -> 
	happyIn83
		 ((PatLitPrim (fst happy_var_1), snd happy_var_1)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_301 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_301 = happySpecReduce_1  73# happyReduction_301
happyReduction_301 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn83
		 (let L loc (INTLIT x) = happy_var_1 in (PatLitInt x, loc)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_302 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_302 = happySpecReduce_1  73# happyReduction_302
happyReduction_302 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn83
		 (let L loc (FLOATLIT x) = happy_var_1 in (PatLitFloat x, loc)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_303 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_303 = happySpecReduce_2  73# happyReduction_303
happyReduction_303 happy_x_2
	happy_x_1
	 =  case happyOut61 happy_x_2 of { (HappyWrap61 happy_var_2) -> 
	happyIn83
		 ((PatLitPrim (primNegate (fst happy_var_2)), snd happy_var_2)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_304 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_304 = happySpecReduce_2  73# happyReduction_304
happyReduction_304 happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_2 of { happy_var_2 -> 
	happyIn83
		 (let L loc (INTLIT x) = happy_var_2 in (PatLitInt (negate x), loc)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_305 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_305 = happySpecReduce_2  73# happyReduction_305
happyReduction_305 happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_2 of { happy_var_2 -> 
	happyIn83
		 (let L loc (FLOATLIT x) = happy_var_2 in (PatLitFloat (negate x), loc)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_306 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_306 = happyReduce 4# 74# happyReduction_306
happyReduction_306 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut90 happy_x_2 of { (HappyWrap90 happy_var_2) -> 
	case happyOut56 happy_x_4 of { (HappyWrap56 happy_var_4) -> 
	happyIn84
		 (For happy_var_2 happy_var_4
	) `HappyStk` happyRest}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_307 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_307 = happyReduce 4# 74# happyReduction_307
happyReduction_307 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut92 happy_x_2 of { (HappyWrap92 happy_var_2) -> 
	case happyOut56 happy_x_4 of { (HappyWrap56 happy_var_4) -> 
	happyIn84
		 (ForIn happy_var_2 happy_var_4
	) `HappyStk` happyRest}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_308 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_308 = happySpecReduce_2  74# happyReduction_308
happyReduction_308 happy_x_2
	happy_x_1
	 =  case happyOut56 happy_x_2 of { (HappyWrap56 happy_var_2) -> 
	happyIn84
		 (While happy_var_2
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_309 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_309 = happySpecReduce_3  75# happyReduction_309
happyReduction_309 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut88 happy_x_2 of { (HappyWrap88 happy_var_2) -> 
	case happyOutTok happy_x_3 of { (L happy_var_3 RBRACKET) -> 
	happyIn85
		 (let L vloc (INDEXING v) = happy_var_1
              in ((v, vloc), happy_var_2, srcspan happy_var_1 happy_var_3)
	)}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_310 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_310 = happySpecReduce_1  76# happyReduction_310
happyReduction_310 happy_x_1
	 =  case happyOut85 happy_x_1 of { (HappyWrap85 happy_var_1) -> 
	happyIn86
		 (let ((v, vloc), y, loc) = happy_var_1 in ((qualName v, vloc), y, loc)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_311 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_311 = happySpecReduce_3  76# happyReduction_311
happyReduction_311 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut88 happy_x_2 of { (HappyWrap88 happy_var_2) -> 
	case happyOutTok happy_x_3 of { (L happy_var_3 RBRACKET) -> 
	happyIn86
		 (let L vloc (QUALINDEXING qs v) = happy_var_1
                  in ((QualName qs v, vloc), happy_var_2, srcspan happy_var_1 happy_var_3)
	)}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_312 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_312 = happySpecReduce_1  77# happyReduction_312
happyReduction_312 happy_x_1
	 =  case happyOut57 happy_x_1 of { (HappyWrap57 happy_var_1) -> 
	happyIn87
		 (DimFix happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_313 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_313 = happySpecReduce_3  77# happyReduction_313
happyReduction_313 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { (HappyWrap57 happy_var_1) -> 
	case happyOut57 happy_x_3 of { (HappyWrap57 happy_var_3) -> 
	happyIn87
		 (DimSlice (Just happy_var_1) (Just happy_var_3) Nothing
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_314 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_314 = happySpecReduce_2  77# happyReduction_314
happyReduction_314 happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { (HappyWrap57 happy_var_1) -> 
	happyIn87
		 (DimSlice (Just happy_var_1) Nothing Nothing
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_315 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_315 = happySpecReduce_2  77# happyReduction_315
happyReduction_315 happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_2 of { (HappyWrap57 happy_var_2) -> 
	happyIn87
		 (DimSlice Nothing (Just happy_var_2) Nothing
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_316 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_316 = happySpecReduce_1  77# happyReduction_316
happyReduction_316 happy_x_1
	 =  happyIn87
		 (DimSlice Nothing Nothing Nothing
	)

#if __GLASGOW_HASKELL__ >= 710
happyReduce_317 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_317 = happyReduce 5# 77# happyReduction_317
happyReduction_317 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut57 happy_x_1 of { (HappyWrap57 happy_var_1) -> 
	case happyOut57 happy_x_3 of { (HappyWrap57 happy_var_3) -> 
	case happyOut57 happy_x_5 of { (HappyWrap57 happy_var_5) -> 
	happyIn87
		 (DimSlice (Just happy_var_1) (Just happy_var_3) (Just happy_var_5)
	) `HappyStk` happyRest}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_318 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_318 = happyReduce 4# 77# happyReduction_318
happyReduction_318 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut57 happy_x_2 of { (HappyWrap57 happy_var_2) -> 
	case happyOut57 happy_x_4 of { (HappyWrap57 happy_var_4) -> 
	happyIn87
		 (DimSlice Nothing (Just happy_var_2) (Just happy_var_4)
	) `HappyStk` happyRest}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_319 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_319 = happyReduce 4# 77# happyReduction_319
happyReduction_319 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut57 happy_x_1 of { (HappyWrap57 happy_var_1) -> 
	case happyOut57 happy_x_4 of { (HappyWrap57 happy_var_4) -> 
	happyIn87
		 (DimSlice (Just happy_var_1) Nothing (Just happy_var_4)
	) `HappyStk` happyRest}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_320 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_320 = happySpecReduce_3  77# happyReduction_320
happyReduction_320 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_3 of { (HappyWrap57 happy_var_3) -> 
	happyIn87
		 (DimSlice Nothing Nothing (Just happy_var_3)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_321 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_321 = happySpecReduce_0  78# happyReduction_321
happyReduction_321  =  happyIn88
		 ([]
	)

#if __GLASGOW_HASKELL__ >= 710
happyReduce_322 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_322 = happySpecReduce_1  78# happyReduction_322
happyReduction_322 happy_x_1
	 =  case happyOut89 happy_x_1 of { (HappyWrap89 happy_var_1) -> 
	happyIn88
		 (fst happy_var_1 : snd happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_323 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_323 = happySpecReduce_1  79# happyReduction_323
happyReduction_323 happy_x_1
	 =  case happyOut87 happy_x_1 of { (HappyWrap87 happy_var_1) -> 
	happyIn89
		 ((happy_var_1, [])
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_324 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_324 = happySpecReduce_3  79# happyReduction_324
happyReduction_324 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut87 happy_x_1 of { (HappyWrap87 happy_var_1) -> 
	case happyOut89 happy_x_3 of { (HappyWrap89 happy_var_3) -> 
	happyIn89
		 ((happy_var_1, fst happy_var_3 : snd happy_var_3)
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_325 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_325 = happySpecReduce_1  80# happyReduction_325
happyReduction_325 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn90
		 (let L loc (ID name) = happy_var_1 in Ident name NoInfo loc
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_326 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_326 = happySpecReduce_1  81# happyReduction_326
happyReduction_326 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn91
		 (let L loc (ID name) = happy_var_1 in (name, loc)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_327 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_327 = happySpecReduce_1  81# happyReduction_327
happyReduction_327 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn91
		 (let L loc (INTLIT n) = happy_var_1 in (nameFromString (show n), loc)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_328 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_328 = happyReduce 4# 82# happyReduction_328
happyReduction_328 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { (L happy_var_1 HASH_LBRACKET) -> 
	case happyOut99 happy_x_2 of { (HappyWrap99 happy_var_2) -> 
	case happyOut92 happy_x_4 of { (HappyWrap92 happy_var_4) -> 
	happyIn92
		 (PatAttr happy_var_2 happy_var_4 (srcspan happy_var_1 happy_var_4)
	) `HappyStk` happyRest}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_329 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_329 = happySpecReduce_3  82# happyReduction_329
happyReduction_329 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut94 happy_x_1 of { (HappyWrap94 happy_var_1) -> 
	case happyOut36 happy_x_3 of { (HappyWrap36 happy_var_3) -> 
	happyIn92
		 (PatAscription happy_var_1 happy_var_3 (srcspan happy_var_1 happy_var_3)
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_330 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_330 = happySpecReduce_1  82# happyReduction_330
happyReduction_330 happy_x_1
	 =  case happyOut94 happy_x_1 of { (HappyWrap94 happy_var_1) -> 
	happyIn92
		 (happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_331 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_331 = happySpecReduce_1  83# happyReduction_331
happyReduction_331 happy_x_1
	 =  case happyOut92 happy_x_1 of { (HappyWrap92 happy_var_1) -> 
	happyIn93
		 ([happy_var_1]
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_332 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_332 = happySpecReduce_3  83# happyReduction_332
happyReduction_332 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut92 happy_x_1 of { (HappyWrap92 happy_var_1) -> 
	case happyOut93 happy_x_3 of { (HappyWrap93 happy_var_3) -> 
	happyIn93
		 (happy_var_1 : happy_var_3
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_333 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_333 = happySpecReduce_1  84# happyReduction_333
happyReduction_333 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn94
		 (let L loc (ID name) = happy_var_1 in Id name NoInfo loc
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_334 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_334 = happySpecReduce_3  84# happyReduction_334
happyReduction_334 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { (L happy_var_1 LPAR) -> 
	case happyOut33 happy_x_2 of { (HappyWrap33 happy_var_2) -> 
	case happyOutTok happy_x_3 of { (L happy_var_3 RPAR) -> 
	happyIn94
		 (Id happy_var_2 NoInfo (srcspan happy_var_1 happy_var_3)
	)}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_335 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_335 = happySpecReduce_1  84# happyReduction_335
happyReduction_335 happy_x_1
	 =  case happyOutTok happy_x_1 of { (L happy_var_1 UNDERSCORE) -> 
	happyIn94
		 (Wildcard NoInfo happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_336 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_336 = happySpecReduce_2  84# happyReduction_336
happyReduction_336 happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { (L happy_var_1 LPAR) -> 
	case happyOutTok happy_x_2 of { (L happy_var_2 RPAR) -> 
	happyIn94
		 (TuplePat [] (srcspan happy_var_1 happy_var_2)
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_337 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_337 = happySpecReduce_3  84# happyReduction_337
happyReduction_337 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { (L happy_var_1 LPAR) -> 
	case happyOut92 happy_x_2 of { (HappyWrap92 happy_var_2) -> 
	case happyOutTok happy_x_3 of { (L happy_var_3 RPAR) -> 
	happyIn94
		 (PatParens happy_var_2 (srcspan happy_var_1 happy_var_3)
	)}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_338 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_338 = happyReduce 5# 84# happyReduction_338
happyReduction_338 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { (L happy_var_1 LPAR) -> 
	case happyOut92 happy_x_2 of { (HappyWrap92 happy_var_2) -> 
	case happyOut93 happy_x_4 of { (HappyWrap93 happy_var_4) -> 
	case happyOutTok happy_x_5 of { (L happy_var_5 RPAR) -> 
	happyIn94
		 (TuplePat (happy_var_2:happy_var_4) (srcspan happy_var_1 happy_var_5)
	) `HappyStk` happyRest}}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_339 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_339 = happySpecReduce_3  84# happyReduction_339
happyReduction_339 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { (L happy_var_1 LCURLY) -> 
	case happyOut96 happy_x_2 of { (HappyWrap96 happy_var_2) -> 
	case happyOutTok happy_x_3 of { (L happy_var_3 RCURLY) -> 
	happyIn94
		 (RecordPat happy_var_2 (srcspan happy_var_1 happy_var_3)
	)}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_340 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_340 = happySpecReduce_3  85# happyReduction_340
happyReduction_340 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut91 happy_x_1 of { (HappyWrap91 happy_var_1) -> 
	case happyOut92 happy_x_3 of { (HappyWrap92 happy_var_3) -> 
	happyIn95
		 ((fst happy_var_1, happy_var_3)
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_341 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_341 = happySpecReduce_3  85# happyReduction_341
happyReduction_341 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut91 happy_x_1 of { (HappyWrap91 happy_var_1) -> 
	case happyOut36 happy_x_3 of { (HappyWrap36 happy_var_3) -> 
	happyIn95
		 ((fst happy_var_1, PatAscription (Id (fst happy_var_1) NoInfo (snd happy_var_1)) happy_var_3 (srcspan (snd happy_var_1) happy_var_3))
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_342 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_342 = happySpecReduce_1  85# happyReduction_342
happyReduction_342 happy_x_1
	 =  case happyOut91 happy_x_1 of { (HappyWrap91 happy_var_1) -> 
	happyIn95
		 ((fst happy_var_1, Id (fst happy_var_1) NoInfo (snd happy_var_1))
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_343 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_343 = happySpecReduce_1  86# happyReduction_343
happyReduction_343 happy_x_1
	 =  case happyOut97 happy_x_1 of { (HappyWrap97 happy_var_1) -> 
	happyIn96
		 (happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_344 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_344 = happySpecReduce_0  86# happyReduction_344
happyReduction_344  =  happyIn96
		 ([]
	)

#if __GLASGOW_HASKELL__ >= 710
happyReduce_345 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_345 = happySpecReduce_3  87# happyReduction_345
happyReduction_345 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut95 happy_x_1 of { (HappyWrap95 happy_var_1) -> 
	case happyOut97 happy_x_3 of { (HappyWrap97 happy_var_3) -> 
	happyIn97
		 (happy_var_1 : happy_var_3
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_346 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_346 = happySpecReduce_1  87# happyReduction_346
happyReduction_346 happy_x_1
	 =  case happyOut95 happy_x_1 of { (HappyWrap95 happy_var_1) -> 
	happyIn97
		 ([happy_var_1]
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_347 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_347 = happySpecReduce_1  88# happyReduction_347
happyReduction_347 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn98
		 (let L loc (ID s) =     happy_var_1 in (AtomName s, loc)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_348 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_348 = happySpecReduce_1  88# happyReduction_348
happyReduction_348 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn98
		 (let L loc (INTLIT x) = happy_var_1 in (AtomInt x, loc)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_349 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_349 = happySpecReduce_1  89# happyReduction_349
happyReduction_349 happy_x_1
	 =  case happyOut98 happy_x_1 of { (HappyWrap98 happy_var_1) -> 
	happyIn99
		 (uncurry AttrAtom happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_350 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_350 = happySpecReduce_3  89# happyReduction_350
happyReduction_350 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_3 of { (L happy_var_3 RPAR) -> 
	happyIn99
		 (let L _ (ID s) = happy_var_1 in AttrComp s [] (srcspan happy_var_1 happy_var_3)
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_351 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_351 = happyReduce 4# 89# happyReduction_351
happyReduction_351 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut100 happy_x_3 of { (HappyWrap100 happy_var_3) -> 
	case happyOutTok happy_x_4 of { (L happy_var_4 RPAR) -> 
	happyIn99
		 (let L _ (ID s) = happy_var_1 in AttrComp s happy_var_3 (srcspan happy_var_1 happy_var_4)
	) `HappyStk` happyRest}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_352 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_352 = happySpecReduce_1  90# happyReduction_352
happyReduction_352 happy_x_1
	 =  case happyOut99 happy_x_1 of { (HappyWrap99 happy_var_1) -> 
	happyIn100
		 ([happy_var_1]
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_353 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_353 = happySpecReduce_3  90# happyReduction_353
happyReduction_353 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut99 happy_x_1 of { (HappyWrap99 happy_var_1) -> 
	case happyOut100 happy_x_3 of { (HappyWrap100 happy_var_3) -> 
	happyIn100
		 (happy_var_1 : happy_var_3
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_354 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_354 = happySpecReduce_1  91# happyReduction_354
happyReduction_354 happy_x_1
	 =  case happyOut104 happy_x_1 of { (HappyWrap104 happy_var_1) -> 
	happyIn101
		 (happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_355 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_355 = happySpecReduce_1  91# happyReduction_355
happyReduction_355 happy_x_1
	 =  case happyOut105 happy_x_1 of { (HappyWrap105 happy_var_1) -> 
	happyIn101
		 (happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_356 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_356 = happySpecReduce_1  91# happyReduction_356
happyReduction_356 happy_x_1
	 =  case happyOut106 happy_x_1 of { (HappyWrap106 happy_var_1) -> 
	happyIn101
		 (happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_357 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_357 = happySpecReduce_1  91# happyReduction_357
happyReduction_357 happy_x_1
	 =  case happyOut107 happy_x_1 of { (HappyWrap107 happy_var_1) -> 
	happyIn101
		 (happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_358 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_358 = happySpecReduce_1  91# happyReduction_358
happyReduction_358 happy_x_1
	 =  case happyOut111 happy_x_1 of { (HappyWrap111 happy_var_1) -> 
	happyIn101
		 (happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_359 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_359 = happySpecReduce_2  92# happyReduction_359
happyReduction_359 happy_x_2
	happy_x_1
	 =  case happyOut101 happy_x_1 of { (HappyWrap101 happy_var_1) -> 
	case happyOut102 happy_x_2 of { (HappyWrap102 happy_var_2) -> 
	happyIn102
		 (happy_var_1 : happy_var_2
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_360 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_360 = happySpecReduce_0  92# happyReduction_360
happyReduction_360  =  happyIn102
		 ([]
	)

#if __GLASGOW_HASKELL__ >= 710
happyReduce_361 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_361 = happyMonadReduce 1# 93# happyReduction_361
happyReduction_361 (happy_x_1 `HappyStk`
	happyRest) tk
	 = happyThen ((case happyOutTok happy_x_1 of { happy_var_1 -> 
	( let L loc (ID s) = happy_var_1 in primTypeFromName loc s)})
	) (\r -> happyReturn (happyIn103 r))

#if __GLASGOW_HASKELL__ >= 710
happyReduce_362 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_362 = happySpecReduce_1  94# happyReduction_362
happyReduction_362 happy_x_1
	 =  case happyOut108 happy_x_1 of { (HappyWrap108 happy_var_1) -> 
	happyIn104
		 (PrimValue (SignedValue (fst happy_var_1))
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_363 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_363 = happySpecReduce_2  94# happyReduction_363
happyReduction_363 happy_x_2
	happy_x_1
	 =  case happyOut108 happy_x_2 of { (HappyWrap108 happy_var_2) -> 
	happyIn104
		 (PrimValue (SignedValue (intNegate (fst happy_var_2)))
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_364 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_364 = happySpecReduce_1  94# happyReduction_364
happyReduction_364 happy_x_1
	 =  case happyOut109 happy_x_1 of { (HappyWrap109 happy_var_1) -> 
	happyIn104
		 (PrimValue (UnsignedValue (fst happy_var_1))
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_365 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_365 = happySpecReduce_1  95# happyReduction_365
happyReduction_365 happy_x_1
	 =  case happyOut110 happy_x_1 of { (HappyWrap110 happy_var_1) -> 
	happyIn105
		 (PrimValue (FloatValue (fst happy_var_1))
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_366 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_366 = happySpecReduce_2  95# happyReduction_366
happyReduction_366 happy_x_2
	happy_x_1
	 =  case happyOut110 happy_x_2 of { (HappyWrap110 happy_var_2) -> 
	happyIn105
		 (PrimValue (FloatValue (floatNegate (fst happy_var_2)))
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_367 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_367 = happySpecReduce_1  96# happyReduction_367
happyReduction_367 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn106
		 (let L pos (STRINGLIT s) = happy_var_1 in
                           ArrayValue (arrayFromList $ map (PrimValue . UnsignedValue . Int8Value . fromIntegral) $ BS.unpack $ T.encodeUtf8 s) $ Scalar $ Prim $ Signed Int32
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_368 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_368 = happySpecReduce_1  97# happyReduction_368
happyReduction_368 happy_x_1
	 =  happyIn107
		 (PrimValue $ BoolValue True
	)

#if __GLASGOW_HASKELL__ >= 710
happyReduce_369 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_369 = happySpecReduce_1  97# happyReduction_369
happyReduction_369 happy_x_1
	 =  happyIn107
		 (PrimValue $ BoolValue False
	)

#if __GLASGOW_HASKELL__ >= 710
happyReduce_370 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_370 = happySpecReduce_1  98# happyReduction_370
happyReduction_370 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn108
		 (let L loc (I8LIT num)  = happy_var_1 in (Int8Value num, loc)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_371 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_371 = happySpecReduce_1  98# happyReduction_371
happyReduction_371 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn108
		 (let L loc (I16LIT num) = happy_var_1 in (Int16Value num, loc)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_372 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_372 = happySpecReduce_1  98# happyReduction_372
happyReduction_372 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn108
		 (let L loc (I32LIT num) = happy_var_1 in (Int32Value num, loc)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_373 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_373 = happySpecReduce_1  98# happyReduction_373
happyReduction_373 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn108
		 (let L loc (I64LIT num) = happy_var_1 in (Int64Value num, loc)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_374 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_374 = happySpecReduce_1  98# happyReduction_374
happyReduction_374 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn108
		 (let L loc (INTLIT num) = happy_var_1 in (Int32Value $ fromInteger num, loc)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_375 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_375 = happySpecReduce_1  98# happyReduction_375
happyReduction_375 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn108
		 (let L loc (CHARLIT char) = happy_var_1 in (Int32Value $ fromIntegral $ ord char, loc)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_376 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_376 = happySpecReduce_1  99# happyReduction_376
happyReduction_376 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn109
		 (let L pos (U8LIT num)  = happy_var_1 in (Int8Value $ fromIntegral num, pos)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_377 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_377 = happySpecReduce_1  99# happyReduction_377
happyReduction_377 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn109
		 (let L pos (U16LIT num) = happy_var_1 in (Int16Value $ fromIntegral num, pos)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_378 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_378 = happySpecReduce_1  99# happyReduction_378
happyReduction_378 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn109
		 (let L pos (U32LIT num) = happy_var_1 in (Int32Value $ fromIntegral num, pos)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_379 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_379 = happySpecReduce_1  99# happyReduction_379
happyReduction_379 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn109
		 (let L pos (U64LIT num) = happy_var_1 in (Int64Value $ fromIntegral num, pos)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_380 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_380 = happySpecReduce_1  100# happyReduction_380
happyReduction_380 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn110
		 (let L loc (F16LIT num) = happy_var_1 in (Float16Value num, loc)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_381 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_381 = happySpecReduce_1  100# happyReduction_381
happyReduction_381 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn110
		 (let L loc (F32LIT num) = happy_var_1 in (Float32Value num, loc)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_382 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_382 = happySpecReduce_1  100# happyReduction_382
happyReduction_382 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn110
		 (let L loc (F64LIT num) = happy_var_1 in (Float64Value num, loc)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_383 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_383 = happyMonadReduce 1# 100# happyReduction_383
happyReduction_383 (happy_x_1 `HappyStk`
	happyRest) tk
	 = happyThen ((case happyOut55 happy_x_1 of { (HappyWrap55 happy_var_1) -> 
	( let (qn, loc) = happy_var_1 in
                       case qn of
                         QualName ["f16"] "inf" -> return (Float16Value (1/0), loc)
                         QualName ["f16"] "nan" -> return (Float16Value (0/0), loc)
                         QualName ["f32"] "inf" -> return (Float32Value (1/0), loc)
                         QualName ["f32"] "nan" -> return (Float32Value (0/0), loc)
                         QualName ["f64"] "inf" -> return (Float64Value (1/0), loc)
                         QualName ["f64"] "nan" -> return (Float64Value (0/0), loc)
                         _ -> parseErrorAt (snd happy_var_1) Nothing)})
	) (\r -> happyReturn (happyIn110 r))

#if __GLASGOW_HASKELL__ >= 710
happyReduce_384 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_384 = happySpecReduce_1  100# happyReduction_384
happyReduction_384 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn110
		 (let L loc (FLOATLIT num) = happy_var_1 in (Float64Value num, loc)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_385 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_385 = happyMonadReduce 3# 101# happyReduction_385
happyReduction_385 (happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest) tk
	 = happyThen ((case happyOut101 happy_x_2 of { (HappyWrap101 happy_var_2) -> 
	( return $ ArrayValue (arrayFromList [happy_var_2]) $
                arrayOf (valueType happy_var_2) (ShapeDecl [1]) Unique)})
	) (\r -> happyReturn (happyIn111 r))

#if __GLASGOW_HASKELL__ >= 710
happyReduce_386 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_386 = happyMonadReduce 5# 101# happyReduction_386
happyReduction_386 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest) tk
	 = happyThen ((case happyOut101 happy_x_2 of { (HappyWrap101 happy_var_2) -> 
	case happyOut114 happy_x_4 of { (HappyWrap114 happy_var_4) -> 
	( case combArrayElements happy_var_2 happy_var_4 of
                  Left e -> throwError e
                  Right v -> return $ ArrayValue (arrayFromList $ happy_var_2:happy_var_4) $
                             arrayOf (valueType v) (ShapeDecl [1+fromIntegral (length happy_var_4)]) Unique)}})
	) (\r -> happyReturn (happyIn111 r))

#if __GLASGOW_HASKELL__ >= 710
happyReduce_387 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_387 = happyMonadReduce 4# 101# happyReduction_387
happyReduction_387 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest) tk
	 = happyThen ((case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { (L happy_var_2 LPAR) -> 
	case happyOut113 happy_x_3 of { (HappyWrap113 happy_var_3) -> 
	case happyOutTok happy_x_4 of { (L happy_var_4 RPAR) -> 
	( (happy_var_1 `mustBe` "empty") >> mustBeEmpty (srcspan happy_var_2 happy_var_4) happy_var_3 >> return (ArrayValue (listArray (0,-1) []) happy_var_3))}}}})
	) (\r -> happyReturn (happyIn111 r))

#if __GLASGOW_HASKELL__ >= 710
happyReduce_388 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_388 = happyMonadReduce 2# 101# happyReduction_388
happyReduction_388 (happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest) tk
	 = happyThen ((case happyOutTok happy_x_1 of { (L happy_var_1 LBRACKET) -> 
	( emptyArrayError happy_var_1)})
	) (\r -> happyReturn (happyIn111 r))

#if __GLASGOW_HASKELL__ >= 710
happyReduce_389 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_389 = happySpecReduce_1  102# happyReduction_389
happyReduction_389 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn112
		 (let L _ (INTLIT num) = happy_var_1 in fromInteger num
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_390 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_390 = happyReduce 4# 103# happyReduction_390
happyReduction_390 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut112 happy_x_2 of { (HappyWrap112 happy_var_2) -> 
	case happyOut113 happy_x_4 of { (HappyWrap113 happy_var_4) -> 
	happyIn113
		 (arrayOf happy_var_4 (ShapeDecl [happy_var_2]) Nonunique
	) `HappyStk` happyRest}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_391 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_391 = happyReduce 4# 103# happyReduction_391
happyReduction_391 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut112 happy_x_2 of { (HappyWrap112 happy_var_2) -> 
	case happyOut103 happy_x_4 of { (HappyWrap103 happy_var_4) -> 
	happyIn113
		 (arrayOf (Scalar (Prim happy_var_4)) (ShapeDecl [happy_var_2]) Nonunique
	) `HappyStk` happyRest}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_392 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_392 = happySpecReduce_3  104# happyReduction_392
happyReduction_392 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut101 happy_x_1 of { (HappyWrap101 happy_var_1) -> 
	case happyOut114 happy_x_3 of { (HappyWrap114 happy_var_3) -> 
	happyIn114
		 (happy_var_1 : happy_var_3
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_393 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_393 = happySpecReduce_1  104# happyReduction_393
happyReduction_393 happy_x_1
	 =  case happyOut101 happy_x_1 of { (HappyWrap101 happy_var_1) -> 
	happyIn114
		 ([happy_var_1]
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_394 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_394 = happySpecReduce_0  104# happyReduction_394
happyReduction_394  =  happyIn114
		 ([]
	)

#if __GLASGOW_HASKELL__ >= 710
happyReduce_395 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_395 = happySpecReduce_2  105# happyReduction_395
happyReduction_395 happy_x_2
	happy_x_1
	 =  case happyOut15 happy_x_2 of { (HappyWrap15 happy_var_2) -> 
	happyIn115
		 (Just happy_var_2
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_396 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_396 = happySpecReduce_0  105# happyReduction_396
happyReduction_396  =  happyIn115
		 (Nothing
	)

#if __GLASGOW_HASKELL__ >= 710
happyReduce_397 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_397 = happySpecReduce_2  106# happyReduction_397
happyReduction_397 happy_x_2
	happy_x_1
	 =  case happyOut21 happy_x_2 of { (HappyWrap21 happy_var_2) -> 
	happyIn116
		 (Just happy_var_2
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_398 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_398 = happySpecReduce_0  106# happyReduction_398
happyReduction_398  =  happyIn116
		 (Nothing
	)

#if __GLASGOW_HASKELL__ >= 710
happyReduce_399 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_399 = happySpecReduce_2  107# happyReduction_399
happyReduction_399 happy_x_2
	happy_x_1
	 =  case happyOut36 happy_x_2 of { (HappyWrap36 happy_var_2) -> 
	happyIn117
		 (Just happy_var_2
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_400 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_400 = happySpecReduce_0  107# happyReduction_400
happyReduction_400  =  happyIn117
		 (Nothing
	)

#if __GLASGOW_HASKELL__ >= 710
happyReduce_401 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_401 = happySpecReduce_2  108# happyReduction_401
happyReduction_401 happy_x_2
	happy_x_1
	 =  case happyOut40 happy_x_2 of { (HappyWrap40 happy_var_2) -> 
	happyIn118
		 (Just happy_var_2
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_402 :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)
#endif
happyReduce_402 = happySpecReduce_0  108# happyReduction_402
happyReduction_402  =  happyIn118
		 (Nothing
	)

happyNewToken action sts stk
	= lexer(\tk -> 
	let cont i = happyDoAction i tk action sts stk in
	case tk of {
	L _ EOF -> happyDoAction 102# tk action sts stk;
	L happy_dollar_dollar IF -> cont 1#;
	L happy_dollar_dollar THEN -> cont 2#;
	L happy_dollar_dollar ELSE -> cont 3#;
	L happy_dollar_dollar LET -> cont 4#;
	L happy_dollar_dollar DEF -> cont 5#;
	L happy_dollar_dollar LOOP -> cont 6#;
	L happy_dollar_dollar IN -> cont 7#;
	L happy_dollar_dollar MATCH -> cont 8#;
	L happy_dollar_dollar CASE -> cont 9#;
	L _ (ID _) -> cont 10#;
	L _ (INDEXING _) -> cont 11#;
	L _ (QUALINDEXING _ _) -> cont 12#;
	L _ (QUALPAREN _ _) -> cont 13#;
	L _ (CONSTRUCTOR _) -> cont 14#;
	L _ (PROJ_INTFIELD _) -> cont 15#;
	L _ (INTLIT _) -> cont 16#;
	L _ (I8LIT _) -> cont 17#;
	L _ (I16LIT _) -> cont 18#;
	L _ (I32LIT _) -> cont 19#;
	L _ (I64LIT _) -> cont 20#;
	L _ (U8LIT _) -> cont 21#;
	L _ (U16LIT _) -> cont 22#;
	L _ (U32LIT _) -> cont 23#;
	L _ (U64LIT _) -> cont 24#;
	L _ (FLOATLIT _) -> cont 25#;
	L _ (F16LIT _) -> cont 26#;
	L _ (F32LIT _) -> cont 27#;
	L _ (F64LIT _) -> cont 28#;
	L _ (STRINGLIT _) -> cont 29#;
	L _ (CHARLIT _) -> cont 30#;
	L happy_dollar_dollar DOT -> cont 31#;
	L happy_dollar_dollar TWO_DOTS -> cont 32#;
	L happy_dollar_dollar THREE_DOTS -> cont 33#;
	L happy_dollar_dollar TWO_DOTS_LT -> cont 34#;
	L happy_dollar_dollar TWO_DOTS_GT -> cont 35#;
	L happy_dollar_dollar EQU -> cont 36#;
	L happy_dollar_dollar ASTERISK -> cont 37#;
	L happy_dollar_dollar NEGATE -> cont 38#;
	L happy_dollar_dollar BANG -> cont 39#;
	L happy_dollar_dollar LTH -> cont 40#;
	L happy_dollar_dollar HAT -> cont 41#;
	L happy_dollar_dollar TILDE -> cont 42#;
	L happy_dollar_dollar PIPE -> cont 43#;
	L _ (SYMBOL Plus _ _) -> cont 44#;
	L _ (SYMBOL Minus _ _) -> cont 45#;
	L _ (SYMBOL Times _ _) -> cont 46#;
	L _ (SYMBOL Divide _ _) -> cont 47#;
	L _ (SYMBOL Mod _ _) -> cont 48#;
	L _ (SYMBOL Quot _ _) -> cont 49#;
	L _ (SYMBOL Rem _ _) -> cont 50#;
	L _ (SYMBOL Equal _ _) -> cont 51#;
	L _ (SYMBOL NotEqual _ _) -> cont 52#;
	L _ (SYMBOL Less _ _) -> cont 53#;
	L _ (SYMBOL Greater _ _) -> cont 54#;
	L _ (SYMBOL Leq _ _) -> cont 55#;
	L _ (SYMBOL Geq _ _) -> cont 56#;
	L _ (SYMBOL Pow _ _) -> cont 57#;
	L _ (SYMBOL ShiftL _ _) -> cont 58#;
	L _ (SYMBOL ShiftR _ _) -> cont 59#;
	L _ (SYMBOL PipeRight _ _) -> cont 60#;
	L _ (SYMBOL PipeLeft _ _) -> cont 61#;
	L _ (SYMBOL Bor _ _) -> cont 62#;
	L _ (SYMBOL Band _ _) -> cont 63#;
	L _ (SYMBOL Xor _ _) -> cont 64#;
	L _ (SYMBOL LogOr _ _) -> cont 65#;
	L _ (SYMBOL LogAnd _ _) -> cont 66#;
	L happy_dollar_dollar LPAR -> cont 67#;
	L happy_dollar_dollar RPAR -> cont 68#;
	L happy_dollar_dollar RPAR_THEN_LBRACKET -> cont 69#;
	L happy_dollar_dollar LCURLY -> cont 70#;
	L happy_dollar_dollar RCURLY -> cont 71#;
	L happy_dollar_dollar LBRACKET -> cont 72#;
	L happy_dollar_dollar RBRACKET -> cont 73#;
	L happy_dollar_dollar HASH_LBRACKET -> cont 74#;
	L happy_dollar_dollar COMMA -> cont 75#;
	L happy_dollar_dollar UNDERSCORE -> cont 76#;
	L happy_dollar_dollar BACKSLASH -> cont 77#;
	L happy_dollar_dollar APOSTROPHE -> cont 78#;
	L happy_dollar_dollar APOSTROPHE_THEN_HAT -> cont 79#;
	L happy_dollar_dollar APOSTROPHE_THEN_TILDE -> cont 80#;
	L happy_dollar_dollar BACKTICK -> cont 81#;
	L happy_dollar_dollar ENTRY -> cont 82#;
	L happy_dollar_dollar RIGHT_ARROW -> cont 83#;
	L happy_dollar_dollar COLON -> cont 84#;
	L happy_dollar_dollar COLON_GT -> cont 85#;
	L happy_dollar_dollar QUESTION_MARK -> cont 86#;
	L happy_dollar_dollar FOR -> cont 87#;
	L happy_dollar_dollar DO -> cont 88#;
	L happy_dollar_dollar WITH -> cont 89#;
	L happy_dollar_dollar ASSERT -> cont 90#;
	L happy_dollar_dollar TRUE -> cont 91#;
	L happy_dollar_dollar FALSE -> cont 92#;
	L happy_dollar_dollar WHILE -> cont 93#;
	L happy_dollar_dollar INCLUDE -> cont 94#;
	L happy_dollar_dollar IMPORT -> cont 95#;
	L happy_dollar_dollar TYPE -> cont 96#;
	L happy_dollar_dollar MODULE -> cont 97#;
	L happy_dollar_dollar VAL -> cont 98#;
	L happy_dollar_dollar OPEN -> cont 99#;
	L happy_dollar_dollar LOCAL -> cont 100#;
	L _  (DOC _) -> cont 101#;
	_ -> happyError' (tk, [])
	})

happyError_ explist 102# tk = happyError' (tk, explist)
happyError_ explist _ tk = happyError' (tk, explist)

happyThen :: () => ParserMonad a -> (a -> ParserMonad b) -> ParserMonad b
happyThen = (Prelude.>>=)
happyReturn :: () => a -> ParserMonad a
happyReturn = (Prelude.return)
#if __GLASGOW_HASKELL__ >= 710
happyParse :: () => Happy_GHC_Exts.Int# -> ParserMonad (HappyAbsSyn _ _ _ _)

happyNewToken :: () => Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)

happyDoAction :: () => Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _)

happyReduceArr :: () => Happy_Data_Array.Array Prelude.Int (Happy_GHC_Exts.Int# -> L Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _) -> ParserMonad (HappyAbsSyn _ _ _ _))

#endif
happyThen1 :: () => ParserMonad a -> (a -> ParserMonad b) -> ParserMonad b
happyThen1 = happyThen
happyReturn1 :: () => a -> ParserMonad a
happyReturn1 = happyReturn
happyError' :: () => ((L Token), [Prelude.String]) -> ParserMonad a
happyError' tk = parseError tk
prog = happySomeParser where
 happySomeParser = happyThen (happyParse 0#) (\x -> happyReturn (let {(HappyWrap11 x') = happyOut11 x} in x'))

futharkType = happySomeParser where
 happySomeParser = happyThen (happyParse 1#) (\x -> happyReturn (let {(HappyWrap38 x') = happyOut38 x} in x'))

expression = happySomeParser where
 happySomeParser = happyThen (happyParse 2#) (\x -> happyReturn (let {(HappyWrap56 x') = happyOut56 x} in x'))

modExpression = happySomeParser where
 happySomeParser = happyThen (happyParse 3#) (\x -> happyReturn (let {(HappyWrap18 x') = happyOut18 x} in x'))

declaration = happySomeParser where
 happySomeParser = happyThen (happyParse 4#) (\x -> happyReturn (let {(HappyWrap12 x') = happyOut12 x} in x'))

anyValue = happySomeParser where
 happySomeParser = happyThen (happyParse 5#) (\x -> happyReturn (let {(HappyWrap101 x') = happyOut101 x} in x'))

anyValues = happySomeParser where
 happySomeParser = happyThen (happyParse 6#) (\x -> happyReturn (let {(HappyWrap102 x') = happyOut102 x} in x'))

happySeq = happyDontSeq


addDoc :: DocComment -> UncheckedDec -> UncheckedDec
addDoc doc (ValDec val) = ValDec (val { valBindDoc = Just doc })
addDoc doc (TypeDec tp) = TypeDec (tp { typeDoc = Just doc })
addDoc doc (SigDec sig) = SigDec (sig { sigDoc = Just doc })
addDoc doc (ModDec mod) = ModDec (mod { modDoc = Just doc })
addDoc _ dec = dec

addDocSpec :: DocComment -> SpecBase NoInfo Name -> SpecBase NoInfo Name
addDocSpec doc (TypeAbbrSpec tpsig) = TypeAbbrSpec (tpsig { typeDoc = Just doc })
addDocSpec doc val@(ValSpec {}) = val { specDoc = Just doc }
addDocSpec doc (TypeSpec l name ps _ loc) = TypeSpec l name ps (Just doc) loc
addDocSpec doc (ModSpec name se _ loc) = ModSpec name se (Just doc) loc
addDocSpec _ spec = spec

addAttr :: AttrInfo Name -> UncheckedDec -> UncheckedDec
addAttr attr (ValDec val) =
  ValDec $ val { valBindAttrs = attr : valBindAttrs val }
addAttr attr dec =
  dec

-- We will extend this function once we actually start tracking these.
addAttrSpec :: AttrInfo Name -> UncheckedSpec -> UncheckedSpec
addAttrSpec _attr dec = dec

reverseNonempty :: (a, [a]) -> (a, [a])
reverseNonempty (x, l) =
  case reverse (x:l) of
    x':rest -> (x', rest)
    []      -> (x, [])

mustBe (L loc (ID got)) expected
  | nameToString got == expected = return ()
mustBe (L loc _) expected =
  parseErrorAt loc $ Just $
  "Only the keyword '" ++ expected ++ "' may appear here."

mustBeEmpty :: SrcLoc -> ValueType -> ParserMonad ()
mustBeEmpty loc (Array _ _ _ (ShapeDecl dims))
  | any (==0) dims = return ()
mustBeEmpty loc t =
  parseErrorAt loc $ Just $ pretty t ++ " is not an empty array."

data ParserEnv = ParserEnv {
                 parserFile :: FilePath
               }

type ParserMonad a =
  ExceptT String (
    StateT ParserEnv (
       StateT ([L Token], Pos) ReadLineMonad)) a

data ReadLineMonad a = Value a
                     | GetLine (Maybe T.Text -> ReadLineMonad a)

readLineFromMonad :: ReadLineMonad (Maybe T.Text)
readLineFromMonad = GetLine Value

instance Monad ReadLineMonad where
  return = Value
  Value x >>= f = f x
  GetLine g >>= f = GetLine $ \s -> g s >>= f

instance Functor ReadLineMonad where
  f `fmap` m = do x <- m
                  return $ f x

instance Applicative ReadLineMonad where
  (<*>) = ap

getLinesFromM :: Monad m => m T.Text -> ReadLineMonad a -> m a
getLinesFromM _ (Value x) = return x
getLinesFromM fetch (GetLine f) = do
  s <- fetch
  getLinesFromM fetch $ f $ Just s

getLinesFromTexts :: [T.Text] -> ReadLineMonad a -> Either String a
getLinesFromTexts _ (Value x) = Right x
getLinesFromTexts (x : xs) (GetLine f) = getLinesFromTexts xs $ f $ Just x
getLinesFromTexts [] (GetLine f) = getLinesFromTexts [] $ f Nothing

getNoLines :: ReadLineMonad a -> Either String a
getNoLines (Value x) = Right x
getNoLines (GetLine f) = getNoLines $ f Nothing

combArrayElements :: Value
                  -> [Value]
                  -> Either String Value
combArrayElements t ts = foldM comb t ts
  where comb x y
          | valueType x == valueType y = Right x
          | otherwise                  = Left $ "Elements " ++ pretty x ++ " and " ++
                                         pretty y ++ " cannot exist in same array."

arrayFromList :: [a] -> Array Int a
arrayFromList l = listArray (0, length l-1) l

applyExp :: [UncheckedExp] -> ParserMonad UncheckedExp
applyExp all@((Constr n [] _ loc1):es) =
  return $ Constr n es NoInfo (srcspan loc1 (last all))
applyExp es =
  foldM ap (head es) (tail es)
  where
     ap (AppExp (Index e is floc) _) (ArrayLit xs _ xloc) =
       parseErrorAt (srcspan floc xloc) $
       Just $ pretty $ "Incorrect syntax for multi-dimensional indexing." </>
       "Use" <+> align (ppr index)
       where index = AppExp (Index e (is++map DimFix xs) xloc) NoInfo
     ap f x =
        return $ AppExp (Apply f x NoInfo (srcspan f x)) NoInfo

patternExp :: UncheckedPat -> ParserMonad UncheckedExp
patternExp (Id v _ loc) = return $ Var (qualName v) NoInfo loc
patternExp (TuplePat pats loc) = TupLit <$> (mapM patternExp pats) <*> return loc
patternExp (Wildcard _ loc) = parseErrorAt loc $ Just "cannot have wildcard here."
patternExp (PatAscription pat _ _) = patternExp pat
patternExp (PatParens pat _) = patternExp pat
patternExp (RecordPat fs loc) = RecordLit <$> mapM field fs <*> pure loc
  where field (name, pat) = RecordFieldExplicit name <$> patternExp pat <*> pure loc

eof :: Pos -> L Token
eof pos = L (SrcLoc $ Loc pos pos) EOF

binOpName (L loc (SYMBOL _ qs op)) = (QualName qs op, loc)

binOp x (L loc (SYMBOL _ qs op)) y =
  AppExp (BinOp (QualName qs op, loc) NoInfo (x, NoInfo) (y, NoInfo) (srcspan x y)) NoInfo

getTokens :: ParserMonad ([L Token], Pos)
getTokens = lift $ lift get

putTokens :: ([L Token], Pos) -> ParserMonad ()
putTokens = lift . lift . put

primTypeFromName :: SrcLoc -> Name -> ParserMonad PrimType
primTypeFromName loc s = maybe boom return $ M.lookup s namesToPrimTypes
  where boom = parseErrorAt loc $ Just $ "No type named " ++ nameToString s

getFilename :: ParserMonad FilePath
getFilename = lift $ gets parserFile

intNegate :: IntValue -> IntValue
intNegate (Int8Value v) = Int8Value (-v)
intNegate (Int16Value v) = Int16Value (-v)
intNegate (Int32Value v) = Int32Value (-v)
intNegate (Int64Value v) = Int64Value (-v)

floatNegate :: FloatValue -> FloatValue
floatNegate (Float16Value v) = Float16Value (-v)
floatNegate (Float32Value v) = Float32Value (-v)
floatNegate (Float64Value v) = Float64Value (-v)

primNegate :: PrimValue -> PrimValue
primNegate (FloatValue v) = FloatValue $ floatNegate v
primNegate (SignedValue v) = SignedValue $ intNegate v
primNegate (UnsignedValue v) = UnsignedValue $ intNegate v
primNegate (BoolValue v) = BoolValue $ not v

readLine :: ParserMonad (Maybe T.Text)
readLine = lift $ lift $ lift readLineFromMonad

lexer :: (L Token -> ParserMonad a) -> ParserMonad a
lexer cont = do
  (ts, pos) <- getTokens
  case ts of
    [] -> do
      ended <- lift $ runExceptT $ cont $ eof pos
      case ended of
        Right x -> return x
        Left parse_e -> do
          line <- readLine
          ts' <-
            case line of Nothing -> throwError parse_e
                         Just line' -> return $ scanTokensText (advancePos pos '\n') line'
          (ts'', pos') <-
            case ts' of Right x -> return x
                        Left lex_e  -> throwError lex_e
          case ts'' of
            [] -> cont $ eof pos
            xs -> do
              putTokens (xs, pos')
              lexer cont
    (x : xs) -> do
      putTokens (xs, pos)
      cont x

parseError :: (L Token, [String]) -> ParserMonad a
parseError (L loc EOF, expected) =
  parseErrorAt (srclocOf loc) $ Just $
  unlines ["unexpected end of file.",
           "Expected one of the following: " ++ unwords expected]
parseError (L loc DOC{}, _) =
  parseErrorAt (srclocOf loc) $
  Just "documentation comments ('-- |') are only permitted when preceding declarations."
parseError (L loc tok, expected) =
  parseErrorAt loc $ Just $
  unlines ["unexpected " ++ show tok,
          "Expected one of the following: " ++ unwords expected]

parseErrorAt :: SrcLoc -> Maybe String -> ParserMonad a
parseErrorAt loc Nothing = throwError $ "Error at " ++ locStr loc ++ ": Parse error."
parseErrorAt loc (Just s) = throwError $ "Error at " ++ locStr loc ++ ": " ++ s

emptyArrayError :: SrcLoc -> ParserMonad a
emptyArrayError loc =
  parseErrorAt loc $
  Just "write empty arrays as 'empty(t)', for element type 't'.\n"

twoDotsRange :: SrcLoc -> ParserMonad a
twoDotsRange loc = parseErrorAt loc $ Just "use '...' for ranges, not '..'.\n"

--- Now for the parser interface.

-- | A parse error.  Use 'show' to get a human-readable description.
data ParseError = ParseError String

instance Show ParseError where
  show (ParseError s) = s

parseInMonad :: ParserMonad a -> FilePath -> T.Text
             -> ReadLineMonad (Either ParseError a)
parseInMonad p file program =
  either (Left . ParseError) Right <$> either (return . Left)
  (evalStateT (evalStateT (runExceptT p) env))
  (scanTokensText (Pos file 1 1 0) program)
  where env = ParserEnv file

parseIncremental :: ParserMonad a -> FilePath -> T.Text
                 -> Either ParseError a
parseIncremental p file program =
  either (Left . ParseError) id
  $ getLinesFromTexts (T.lines program)
  $ parseInMonad p file mempty

parse :: ParserMonad a -> FilePath -> T.Text
      -> Either ParseError a
parse p file program =
  either (Left . ParseError) id
  $ getNoLines $ parseInMonad p file program

-- | Parse an Futhark expression incrementally from monadic actions, using the
-- 'FilePath' as the source name for error messages.
parseExpIncrM :: Monad m =>
                 m T.Text -> FilePath -> T.Text
              -> m (Either ParseError UncheckedExp)
parseExpIncrM fetch file program =
  getLinesFromM fetch $ parseInMonad expression file program

-- | Parse either an expression or a declaration incrementally;
-- favouring declarations in case of ambiguity.
parseDecOrExpIncrM :: Monad m =>
                      m T.Text -> FilePath -> T.Text
                   -> m (Either ParseError (Either UncheckedDec UncheckedExp))
parseDecOrExpIncrM fetch file input =
  case parseInMonad declaration file input of
    Value Left{} -> fmap Right <$> parseExpIncrM fetch file input
    Value (Right d) -> return $ Right $ Left d
    GetLine c -> do
      l <- fetch
      parseDecOrExpIncrM fetch file $ input <> "\n" <> l
{-# LINE 1 "templates/GenericTemplate.hs" #-}
-- $Id: GenericTemplate.hs,v 1.26 2005/01/14 14:47:22 simonmar Exp $













-- Do not remove this comment. Required to fix CPP parsing when using GCC and a clang-compiled alex.
#if __GLASGOW_HASKELL__ > 706
#define LT(n,m) ((Happy_GHC_Exts.tagToEnum# (n Happy_GHC_Exts.<# m)) :: Prelude.Bool)
#define GTE(n,m) ((Happy_GHC_Exts.tagToEnum# (n Happy_GHC_Exts.>=# m)) :: Prelude.Bool)
#define EQ(n,m) ((Happy_GHC_Exts.tagToEnum# (n Happy_GHC_Exts.==# m)) :: Prelude.Bool)
#else
#define LT(n,m) (n Happy_GHC_Exts.<# m)
#define GTE(n,m) (n Happy_GHC_Exts.>=# m)
#define EQ(n,m) (n Happy_GHC_Exts.==# m)
#endif



















data Happy_IntList = HappyCons Happy_GHC_Exts.Int# Happy_IntList








































infixr 9 `HappyStk`
data HappyStk a = HappyStk a (HappyStk a)

-----------------------------------------------------------------------------
-- starting the parse

happyParse start_state = happyNewToken start_state notHappyAtAll notHappyAtAll

-----------------------------------------------------------------------------
-- Accepting the parse

-- If the current token is ERROR_TOK, it means we've just accepted a partial
-- parse (a %partial parser).  We must ignore the saved token on the top of
-- the stack in this case.
happyAccept 0# tk st sts (_ `HappyStk` ans `HappyStk` _) =
        happyReturn1 ans
happyAccept j tk st sts (HappyStk ans _) = 
        (happyTcHack j (happyTcHack st)) (happyReturn1 ans)

-----------------------------------------------------------------------------
-- Arrays only: do the next action



happyDoAction i tk st
        = {- nothing -}
          case action of
                0#           -> {- nothing -}
                                     happyFail (happyExpListPerState ((Happy_GHC_Exts.I# (st)) :: Prelude.Int)) i tk st
                -1#          -> {- nothing -}
                                     happyAccept i tk st
                n | LT(n,(0# :: Happy_GHC_Exts.Int#)) -> {- nothing -}
                                                   (happyReduceArr Happy_Data_Array.! rule) i tk st
                                                   where rule = (Happy_GHC_Exts.I# ((Happy_GHC_Exts.negateInt# ((n Happy_GHC_Exts.+# (1# :: Happy_GHC_Exts.Int#))))))
                n                 -> {- nothing -}
                                     happyShift new_state i tk st
                                     where new_state = (n Happy_GHC_Exts.-# (1# :: Happy_GHC_Exts.Int#))
   where off    = happyAdjustOffset (indexShortOffAddr happyActOffsets st)
         off_i  = (off Happy_GHC_Exts.+# i)
         check  = if GTE(off_i,(0# :: Happy_GHC_Exts.Int#))
                  then EQ(indexShortOffAddr happyCheck off_i, i)
                  else Prelude.False
         action
          | check     = indexShortOffAddr happyTable off_i
          | Prelude.otherwise = indexShortOffAddr happyDefActions st




indexShortOffAddr (HappyA# arr) off =
        Happy_GHC_Exts.narrow16Int# i
  where
        i = Happy_GHC_Exts.word2Int# (Happy_GHC_Exts.or# (Happy_GHC_Exts.uncheckedShiftL# high 8#) low)
        high = Happy_GHC_Exts.int2Word# (Happy_GHC_Exts.ord# (Happy_GHC_Exts.indexCharOffAddr# arr (off' Happy_GHC_Exts.+# 1#)))
        low  = Happy_GHC_Exts.int2Word# (Happy_GHC_Exts.ord# (Happy_GHC_Exts.indexCharOffAddr# arr off'))
        off' = off Happy_GHC_Exts.*# 2#




{-# INLINE happyLt #-}
happyLt x y = LT(x,y)


readArrayBit arr bit =
    Bits.testBit (Happy_GHC_Exts.I# (indexShortOffAddr arr ((unbox_int bit) `Happy_GHC_Exts.iShiftRA#` 4#))) (bit `Prelude.mod` 16)
  where unbox_int (Happy_GHC_Exts.I# x) = x






data HappyAddr = HappyA# Happy_GHC_Exts.Addr#


-----------------------------------------------------------------------------
-- HappyState data type (not arrays)













-----------------------------------------------------------------------------
-- Shifting a token

happyShift new_state 0# tk st sts stk@(x `HappyStk` _) =
     let i = (case Happy_GHC_Exts.unsafeCoerce# x of { (Happy_GHC_Exts.I# (i)) -> i }) in
--     trace "shifting the error token" $
     happyDoAction i tk new_state (HappyCons (st) (sts)) (stk)

happyShift new_state i tk st sts stk =
     happyNewToken new_state (HappyCons (st) (sts)) ((happyInTok (tk))`HappyStk`stk)

-- happyReduce is specialised for the common cases.

happySpecReduce_0 i fn 0# tk st sts stk
     = happyFail [] 0# tk st sts stk
happySpecReduce_0 nt fn j tk st@((action)) sts stk
     = happyGoto nt j tk st (HappyCons (st) (sts)) (fn `HappyStk` stk)

happySpecReduce_1 i fn 0# tk st sts stk
     = happyFail [] 0# tk st sts stk
happySpecReduce_1 nt fn j tk _ sts@((HappyCons (st@(action)) (_))) (v1`HappyStk`stk')
     = let r = fn v1 in
       happySeq r (happyGoto nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_2 i fn 0# tk st sts stk
     = happyFail [] 0# tk st sts stk
happySpecReduce_2 nt fn j tk _ (HappyCons (_) (sts@((HappyCons (st@(action)) (_))))) (v1`HappyStk`v2`HappyStk`stk')
     = let r = fn v1 v2 in
       happySeq r (happyGoto nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_3 i fn 0# tk st sts stk
     = happyFail [] 0# tk st sts stk
happySpecReduce_3 nt fn j tk _ (HappyCons (_) ((HappyCons (_) (sts@((HappyCons (st@(action)) (_))))))) (v1`HappyStk`v2`HappyStk`v3`HappyStk`stk')
     = let r = fn v1 v2 v3 in
       happySeq r (happyGoto nt j tk st sts (r `HappyStk` stk'))

happyReduce k i fn 0# tk st sts stk
     = happyFail [] 0# tk st sts stk
happyReduce k nt fn j tk st sts stk
     = case happyDrop (k Happy_GHC_Exts.-# (1# :: Happy_GHC_Exts.Int#)) sts of
         sts1@((HappyCons (st1@(action)) (_))) ->
                let r = fn stk in  -- it doesn't hurt to always seq here...
                happyDoSeq r (happyGoto nt j tk st1 sts1 r)

happyMonadReduce k nt fn 0# tk st sts stk
     = happyFail [] 0# tk st sts stk
happyMonadReduce k nt fn j tk st sts stk =
      case happyDrop k (HappyCons (st) (sts)) of
        sts1@((HappyCons (st1@(action)) (_))) ->
          let drop_stk = happyDropStk k stk in
          happyThen1 (fn stk tk) (\r -> happyGoto nt j tk st1 sts1 (r `HappyStk` drop_stk))

happyMonad2Reduce k nt fn 0# tk st sts stk
     = happyFail [] 0# tk st sts stk
happyMonad2Reduce k nt fn j tk st sts stk =
      case happyDrop k (HappyCons (st) (sts)) of
        sts1@((HappyCons (st1@(action)) (_))) ->
         let drop_stk = happyDropStk k stk

             off = happyAdjustOffset (indexShortOffAddr happyGotoOffsets st1)
             off_i = (off Happy_GHC_Exts.+# nt)
             new_state = indexShortOffAddr happyTable off_i




          in
          happyThen1 (fn stk tk) (\r -> happyNewToken new_state sts1 (r `HappyStk` drop_stk))

happyDrop 0# l = l
happyDrop n (HappyCons (_) (t)) = happyDrop (n Happy_GHC_Exts.-# (1# :: Happy_GHC_Exts.Int#)) t

happyDropStk 0# l = l
happyDropStk n (x `HappyStk` xs) = happyDropStk (n Happy_GHC_Exts.-# (1#::Happy_GHC_Exts.Int#)) xs

-----------------------------------------------------------------------------
-- Moving to a new state after a reduction


happyGoto nt j tk st = 
   {- nothing -}
   happyDoAction j tk new_state
   where off = happyAdjustOffset (indexShortOffAddr happyGotoOffsets st)
         off_i = (off Happy_GHC_Exts.+# nt)
         new_state = indexShortOffAddr happyTable off_i




-----------------------------------------------------------------------------
-- Error recovery (ERROR_TOK is the error token)

-- parse error if we are in recovery and we fail again
happyFail explist 0# tk old_st _ stk@(x `HappyStk` _) =
     let i = (case Happy_GHC_Exts.unsafeCoerce# x of { (Happy_GHC_Exts.I# (i)) -> i }) in
--      trace "failing" $ 
        happyError_ explist i tk

{-  We don't need state discarding for our restricted implementation of
    "error".  In fact, it can cause some bogus parses, so I've disabled it
    for now --SDM

-- discard a state
happyFail  ERROR_TOK tk old_st CONS(HAPPYSTATE(action),sts) 
                                                (saved_tok `HappyStk` _ `HappyStk` stk) =
--      trace ("discarding state, depth " ++ show (length stk))  $
        DO_ACTION(action,ERROR_TOK,tk,sts,(saved_tok`HappyStk`stk))
-}

-- Enter error recovery: generate an error token,
--                       save the old token and carry on.
happyFail explist i tk (action) sts stk =
--      trace "entering error recovery" $
        happyDoAction 0# tk action sts ((Happy_GHC_Exts.unsafeCoerce# (Happy_GHC_Exts.I# (i))) `HappyStk` stk)

-- Internal happy errors:

notHappyAtAll :: a
notHappyAtAll = Prelude.error "Internal Happy error\n"

-----------------------------------------------------------------------------
-- Hack to get the typechecker to accept our action functions


happyTcHack :: Happy_GHC_Exts.Int# -> a -> a
happyTcHack x y = y
{-# INLINE happyTcHack #-}


-----------------------------------------------------------------------------
-- Seq-ing.  If the --strict flag is given, then Happy emits 
--      happySeq = happyDoSeq
-- otherwise it emits
--      happySeq = happyDontSeq

happyDoSeq, happyDontSeq :: a -> b -> b
happyDoSeq   a b = a `Prelude.seq` b
happyDontSeq a b = b

-----------------------------------------------------------------------------
-- Don't inline any functions from the template.  GHC has a nasty habit
-- of deciding to inline happyGoto everywhere, which increases the size of
-- the generated parser quite a bit.


{-# NOINLINE happyDoAction #-}
{-# NOINLINE happyTable #-}
{-# NOINLINE happyCheck #-}
{-# NOINLINE happyActOffsets #-}
{-# NOINLINE happyGotoOffsets #-}
{-# NOINLINE happyDefActions #-}

{-# NOINLINE happyShift #-}
{-# NOINLINE happySpecReduce_0 #-}
{-# NOINLINE happySpecReduce_1 #-}
{-# NOINLINE happySpecReduce_2 #-}
{-# NOINLINE happySpecReduce_3 #-}
{-# NOINLINE happyReduce #-}
{-# NOINLINE happyMonadReduce #-}
{-# NOINLINE happyGoto #-}
{-# NOINLINE happyFail #-}

-- end of Happy Template.
