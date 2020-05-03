## This module contains all functions responsible for parsing and validating
## command line arguments

import os, strutils
import parser
import types
import install
import sync

let helpMessage: string = """
confie - Configuration manager Version 0
(c) 2020 LangHops
Usage:
  confie file [options]
Options:
  -h                     show this help message
  -i, install            installs the list of packages"""
    ## The default help message

proc parseArgs*(argList: seq[TaintedString]): string =
  ## Takes a list of arguments and parses them, executing
  ## the appropriate commands.
  ## Returns a string representing the error or success message

  if paramCount() == 0:
    quit(helpMessage, QuitSuccess)
  elif argList.contains("-h"):
    quit(helpMessage, QuitSuccess)
  elif argList.contains("install"):
    let nextLoc: int = (argList.find("install") + 1)
    if argList.len == nextLoc or argList[nextLoc].startsWith("-"):
      let parsedConfig = parseFileOrDir(getCurrentDir())
      if parsedConfig[0].isEmptyOrWhitespace:
        discard installPackages(parsedConfig[1])
        discard installDotfiles(parsedConfig[1])
      else:
        quit(parsedConfig[0], QuitFailure)      
    else:
      let parsedConfig = parseFileOrDir(getCurrentDir())
      if parsedConfig[0].isEmptyOrWhitespace:
        case argList[nextLoc]:
          of "dotfiles":
            discard installDotfiles(parsedConfig[1])
          of "packages":
            discard installPackages(parsedConfig[1])
          else:
            quit("Error: Unsupported installation candidate", QuitFailure)
        quit(parsedConfig[0], QuitFailure)      
