module Main where

import qualified Data.Text as T
import qualified FileParser as P
import System.Environment
import System.Exit
import System.IO

main :: IO ()
main = getArgs >>= parseArgs

parseArgs :: [String] -> IO ()
parseArgs ["-h"] = usage >> exitWith ExitSuccess
parseArgs []     = usage >> exitWith ExitSuccess
parseArgs ["-v"] = version >> exitWith ExitSuccess
parseArgs [file] = do
  fileHandle <- openFile file ReadMode
  P.parseFile $ T.pack <$> hGetContents fileHandle
  hClose fileHandle
parseArgs args = putStrLn "Too many args!" >> exitWith (ExitFailure 0)

usage :: IO ()
usage = putStrLn "Usage: confie [-vh] FILE"

version :: IO ()
version = putStrLn "Version: 0.0.0.1"
