## This module contains all functions responsible for parsing and validating
## command line arguments

import strutils

let helpMessage*: string = "Usage: confie <file> [-h|-v]"
## The default help message

proc parseArgs*(argList: seq[TaintedString]) =
  ## Takes a list of arguments and parses them
  
  echo argList.join(" ")

