import args
import os

const cmdArgsError*: string = "Error: Could not get command line arguments!"
## Error thrown when confie can't fetch the command line arguments

proc main() =
  when declared(commandLineParams):
    let arglist = commandLineParams()
    discard parseArgs(arglist)
  else:
    quit(cmdArgsError)

when isMainModule:
  main()
