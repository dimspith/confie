module FileParser ( parseFile
                  )where

import TOML
import qualified Data.Text as T


parseFile :: IO T.Text -> IO ()
parseFile contents = do
  values <- parseTOML <$> contents
  print values
