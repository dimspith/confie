## This module contains all functions responsible for parsing and validating
## command line arguments

import os, parser, install, types, colorize, parseopt, strutils

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

proc parseArgs*(argList: seq[TaintedString]) =
  ## Takes a list of arguments and parses them, executing
  ## the appropriate commands.
  ## Returns a string representing the error or success message

  var
    p = initOptParser(argList)
    options: seq[string]
    arguments: seq[string]
    opvals: seq[tuple[op, val: string]]

  if p.remainingArgs.len == 0:
    quit(helpMessage, QuitSuccess)

  while true:
    p.next()
    case p.kind
    of cmdEnd: break
    of cmdShortOption, cmdLongOption:
      if p.val == "":
        options.add(p.key)
      else:
        opvals.add((p.key, p.val))
    of cmdArgument:
      arguments.add(p.key)

  # Print help message if no arguments or -h is supplied
  if arguments.len == 0:
    quit(helpMessage, QuitSuccess)
  elif options.contains("h"):
    quit(helpMessage, QuitSuccess)

  # Parse configuration file on current directory
  let parsedConfig = parseFileOrDir(getCurrentDir())

  if not parsedConfig[0].isEmptyOrWhitespace:
    quit(parsedConfig[0], QuitFailure)

  case arguments[0]:
    of "install":
      if arguments.len == 1:
        echo installPackages(parsedConfig[1])
        echo installDotfiles(parsedConfig[1])
      else:
        case arguments[1]:
          of "dotfiles":
            echo installDotfiles(parsedConfig[1])
          of "packages":
            echo installPackages(parsedConfig[1])
          else:
            quit("Error: ".fgRed &  "Unknown argument '" & arguments[0] & "'", QuitFailure)
    of "fetch":
      echo fetchDotfiles(parsedConfig[1])
    of "print-config":
      echo printConfig(parsedConfig[1])
    else:
      quit("Error: ".fgRed &  "Command '" & arguments[0] & "' not found.", QuitFailure)
