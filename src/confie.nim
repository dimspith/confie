import args
import os

const cmdArgsError*: string = "Error: Could not get command line arguments!"

when isMainModule:
    when declared(commandLineParams):
      let arglist = commandLineParams()
      parseArgs(arglist)
    else:
      quit(cmdArgsError)
