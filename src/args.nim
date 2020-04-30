## This module contains all functions responsible for parsing and validating
## command line arguments

import os, strutils
import parser

let helpMessage: string = """
confie - Configuration manager Version 0
(c) 2020 LangHops
Usage:
  confie file [options]
Options:
  -h                     show this help message """
## The default help message

proc parseFileOrDir(location: TaintedString): string =
  ## Parse the contents of a file or a list of files in a directory
  ## and execute the appropriate commands

  if existsFile location:
    return parseConfig(location)
  elif existsDir location:
    for kind, path in walkDir location:
      result = result & path & "\n"
    return
  else:
    return "Invalid file or directory!"

proc parseArgs*(argList: seq[TaintedString]) =
  ## Takes a list of arguments and parses them,
  ## executing the appropriate commands

  if paramCount() == 0:
    echo helpMessage
    quit(QuitSuccess)
  elif argList.contains("-h"):
    echo helpMessage
    quit(QuitSuccess)
  elif paramCount() == 1:
     echo parseFileOrDir paramStr(1)
  else:
    echo argList.join(" ")
