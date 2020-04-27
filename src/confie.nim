import args
import os

when isMainModule:
  if paramCount() == 0:
    quit(helpMessage)
  else:
    when declared(commandLineParams):
      let args = commandLineParams()
      parseArgs(args)
    else:
      quit()
