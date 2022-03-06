-- | Sequential imperative code.
module Futhark.CodeGen.ImpCode.Sequential
  ( Program,
    Function,
    FunctionT (Function),
    Code,
    Sequential,
    module Futhark.CodeGen.ImpCode,
  )
where

import Futhark.CodeGen.ImpCode hiding (Code, Function)
import qualified Futhark.CodeGen.ImpCode as Imp
import Futhark.Util.Pretty

-- | An imperative program.
type Program = Imp.Definitions Sequential

-- | An imperative function.
type Function = Imp.Function Sequential

-- | A piece of imperative code.
type Code = Imp.Code Sequential

-- | Phantom type for identifying sequential imperative code.
data Sequential

instance Pretty Sequential where
  ppr _ = empty

instance FreeIn Sequential where
  freeIn' _ = mempty
