## Contains all functions responsible for parsing and validating command line arguments

import os, strutils
import parser
import packages, dotfiles
import types


let helpMessage: string = """
confie - Configuration manager Version 0.1.0
(c) 2020 LangHops
Usage:
  confie <command> [target] [options]
Commands:
  install            install packages or dotfiles
  fetch              fetches dotfiles
  print-config       print configuration info
Targets (for install):
  packages           install the list of packages
  dotfiles           install defined dotfiles
Options:
  -h                     show this help message"""
    ## The default help message

proc parseArgs*(argList: seq[TaintedString]): string =
  ## Takes a list of arguments and parses them, executing
  ## the appropriate commands.
  ## Returns a string representing the error or success message

  if paramCount() == 0:
    quit(helpMessage, QuitSuccess)
  elif argList.contains("-h"):
    quit(helpMessage, QuitSuccess)
  else:
    let parsedConfig = parseFileOrDir(getCurrentDir())
    if parsedConfig[0].isEmptyOrWhitespace:
      if argList.contains("install"):
        let nextLoc: int = (argList.find("install") + 1)
        if argList.len == nextLoc or argList[nextLoc].startsWith("-"):
            let installation = installPackages(parsedConfig[1])
            echo(installation)
            if installation == "Installation failed":
              quit("Abort", QuitFailure)
            else:
              echo installDotfiles(parsedConfig[1])
        else:
          if parsedConfig[0].isEmptyOrWhitespace:
            case argList[nextLoc]:
              of "dotfiles":
                echo installDotfiles(parsedConfig[1])
              of "packages":
                echo installPackages(parsedConfig[1])
              else:
                quit("Error: Unsupported installation candidate", QuitFailure)
      elif argList.contains("fetch"):
        echo fetchDotfiles(parsedConfig[1])
      elif argList.contains("print-config"):
        echo printConfig(parsedConfig[1])
      else:
        quit("Command not found", QuitFailure)
    else:
      quit(parsedConfig[0], QuitFailure)
