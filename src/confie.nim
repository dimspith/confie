import args
import os

const cmdArgsError*: string = "Error: Could not get command line arguments!"

proc main() =
  when declared(commandLineParams):
    let arglist = commandLineParams()
    stdout.write parseArgs(arglist)
  else:
    quit(cmdArgsError)

when isMainModule:
  main()
