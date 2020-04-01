{-# LANGUAGE OverloadedStrings #-}
module FileParser ( parseFile
                  )where

import qualified Data.Text as T
import qualified Data.Text.IO as TIO
import Data.Either
import System.Exit

parseFile :: T.Text -> IO ()
parseFile contents = TIO.putStrLn contents
