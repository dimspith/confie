import args, os

const cmdArgsError*: string = "Error: Could not get command line arguments!"
## Error thrown when confie can't fetch the command line arguments

proc exitProc() {.noconv.} =
  quit(0)

setControlCHook(exitProc)

proc main() =
  when declared(commandLineParams):
    let arglist = commandLineParams()
    parseArgs(arglist)
  else:
    quit(cmdArgsError)

when isMainModule:
  main()
