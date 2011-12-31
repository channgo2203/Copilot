--------------------------------------------------------------------------------
-- Copyright © 2011 National Institute of Aerospace / Galois, Inc.
--------------------------------------------------------------------------------

-- | Example in sampling external functions.

{-# LANGUAGE RebindableSyntax #-}

module ExtFuns ( extFuns ) where

import Language.Copilot 
--import qualified Copilot.Compile.C99 as C

--------------------------------------------------------------------------------

nats :: Stream Word16
nats = [0] ++ nats + 1

---------------------------------------------------------------------------------
-- Function func0 and it's environment for interpreting

func0 :: Stream Word16
func0 = externFun "func0" [ funArg x, funArg nats ]
          (Just $ cast x + nats)
  where x = externW8 "x" (Just [0..])
          
---------------------------------------------------------------------------------
-- Function func0 with another set of args and it's environment for interpreting

-- func2 :: Stream Word16
-- func2 = externFun "func0" [ funArg $ constW8 3, funArg $ constW16 4 ]
--           (Just $ constW16 4 + 1)

---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Function func1 and it's environment for interpreting
func1 :: Stream Bool
func1 = externFun "func1" [] (Just $ [False] ++ not func1)

---------------------------------------------------------------------------------

a :: Stream Word16
a = func0 + func0

spec :: Spec
spec = trigger "trigger" true [ arg func0
                              , arg func1
                              , arg a ]
  
extFuns :: IO ()
extFuns = do
--    reify spec >>= C.compile C.defaultParams 
    interpret 10 spec

--------------------------------------------------------------------------------
