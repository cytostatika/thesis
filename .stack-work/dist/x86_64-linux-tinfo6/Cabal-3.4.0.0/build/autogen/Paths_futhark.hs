{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -Wno-missing-safe-haskell-mode #-}
module Paths_futhark (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,22,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/home/gilli/thesis/.stack-work/install/x86_64-linux-tinfo6/0f453b8c74eca8a5e32d812c9b7149dde2042d5ed4201d20d12841c43a0e0537/9.0.1/bin"
libdir     = "/home/gilli/thesis/.stack-work/install/x86_64-linux-tinfo6/0f453b8c74eca8a5e32d812c9b7149dde2042d5ed4201d20d12841c43a0e0537/9.0.1/lib/x86_64-linux-ghc-9.0.1/futhark-0.22.0-6ZZlR3DhXCvKDt42jKB2z1"
dynlibdir  = "/home/gilli/thesis/.stack-work/install/x86_64-linux-tinfo6/0f453b8c74eca8a5e32d812c9b7149dde2042d5ed4201d20d12841c43a0e0537/9.0.1/lib/x86_64-linux-ghc-9.0.1"
datadir    = "/home/gilli/thesis/.stack-work/install/x86_64-linux-tinfo6/0f453b8c74eca8a5e32d812c9b7149dde2042d5ed4201d20d12841c43a0e0537/9.0.1/share/x86_64-linux-ghc-9.0.1/futhark-0.22.0"
libexecdir = "/home/gilli/thesis/.stack-work/install/x86_64-linux-tinfo6/0f453b8c74eca8a5e32d812c9b7149dde2042d5ed4201d20d12841c43a0e0537/9.0.1/libexec/x86_64-linux-ghc-9.0.1/futhark-0.22.0"
sysconfdir = "/home/gilli/thesis/.stack-work/install/x86_64-linux-tinfo6/0f453b8c74eca8a5e32d812c9b7149dde2042d5ed4201d20d12841c43a0e0537/9.0.1/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "futhark_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "futhark_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "futhark_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "futhark_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "futhark_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "futhark_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
