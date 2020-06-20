## Miscellaneous utilities

import terminal, strutils, os

proc setEchoColor*(echoStr: string, color: ForegroundColor) =
  ## Print string with the specified foreground color
  setForegroundColor(stdout, color)
  stdout.write(echoStr)
  setForegroundColor(stdout, fgDefault)

proc verify*(): string =
  ## Prompt to verify user's actions
  while true:
    setEchoColor("==> Proceed with copy?(y/n)\n", fgGreen)
    setEchoColor("==> ", fgGreen)
    let answer = stdin.readLine()
    if answer == "y" or answer == "yes" or answer == "Y":
      return "Continue"
    elif answer == "n" or answer == "no" or answer == "N":
      return "Abort"

proc getPath*(path: string): string =
  ## Normalize path string (expanding tilde e.t.c)
  if path.startsWith("~"):
    return expandTilde(path)
  else:
    return absolutePath(path)
