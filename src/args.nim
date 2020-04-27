## This module contains all functions responsible for parsing and validating
## command line arguments

import os, strutils

let helpMessage: string = "Usage: confie <file> [-h|-v]"
## The default help message

proc parseFileOrDir(location: TaintedString): string =
  ## Parse the contents of a file or a list of files in a directory
  ## and execute the appropriate commands

  if existsFile location:
    let fileContents: string = readFile location
    stdout.write fileContents

  elif existsDir location:
    for kind, path in walkDir location:
      echo path

  else:
    echo "Invalid file or directory!"

proc parseArgs*(argList: seq[TaintedString]) =
  ## Takes a list of arguments and parses them,
  ## executing the appropriate commands

  if paramCount() == 0:
    quit(helpMessage)
  elif argList.contains("-h"):
    quit(helpMessage)
  elif paramCount() == 1:
     stdout.write parseFileOrDir paramStr(1)
  else:
    echo argList.join(" ")

