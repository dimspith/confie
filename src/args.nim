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

proc parseFileOrDir(location: string): string =
  ## Parse the contents of a file or a list of files in a directory
  ## and execute the appropriate commands

  if existsFile location:
    return parseConfig(location)
  elif existsDir location:
    if existsFile (location & "/confie.cfg"):
      return parseConfig (location & "/confie.cfg")
    else:
      return "Directory does not contain a confie.cfg file!"
  else:
    return "Invalid file or directory!"

proc parseArgs*(argList: seq[TaintedString]): string =
  ## Takes a list of arguments and parses them,
  ## executing the appropriate commands

  if paramCount() == 0:
    echo helpMessage
    quit(QuitSuccess)
  elif argList.contains("-h"):
    echo helpMessage
    quit(QuitSuccess)
  elif argList.contains("install"):
    let fileIndex: int = argList.find("install") + 1
    if argList.len < (fileIndex + 1):
      return parseFileOrDir(getCurrentDir())
    else:
      return parseFileOrDir argList[fileIndex]
  else:
    echo argList.join(" ")
