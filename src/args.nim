## This module contains all functions responsible for parsing and validating
## command line arguments

import os, strutils

let helpMessage*: string = "Usage: confie <file> [-h|-v]"
## The default help message

proc parseArgs*(argList: seq[TaintedString]) =
  ## Takes a list of arguments and parses them
  if paramCount() == 0:
    quit(helpMessage)
  elif argList.contains("-h"):
    quit(helpMessage)
  else:
    echo argList.join(" ")

