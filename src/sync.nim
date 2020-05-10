import os, strutils, terminal

proc getPath(path: string): string =
  if path.startsWith("~"):
    return expandTilde(path)
  else:
    return absolutePath(path)

proc setEchoColor*(echoStr: string, color: ForegroundColor) =
  setForegroundColor(stdout, color)
  stdout.write(echoStr)
  setForegroundColor(stdout, fgDefault)

proc overwriteDot(source, dest, oldSource, oldDest: string, ftype: int) =
  while true:
    setEchoColor("==> " & oldDest & " already exists. Do you want to overwrite it?(y/n)\n",
      fgGreen)
    setEchoColor("==> ", fgGreen)
    let answer = stdin.readLine()
    if answer == "y" or answer == "yes" or answer == "Y":
      setEchoColor("==> Copying " & oldSource & " to " & oldDest & "\n", fgBlue)
      if ftype == 0:
        copyDir(source, dest)
      elif ftype == 1:
        copyFile(source, dest)
      else:
        setEchoColor("Not a file or directory.\n", fgRed)
      return
    elif answer == "n" or answer == "no" or answer == "N":
      setEchoColor("Skipping " & oldSource & "\n", fgYellow)
      return

func addTail(source, dest: string): string =
  let sourcePath = splitPath(source)
  let destPath = splitPath(dest)
  if (destPath.tail == sourcePath.tail) and ((fileExists(destPath.tail) and
      fileExists(sourcePath.tail)) or (dirExists(destPath.tail) and dirExists(
      sourcePath.tail))):
    return dest
  else:
    return dest/sourcePath.tail

proc copyDots*(source, dest: string): string =
  if source.isEmptyOrWhitespace or dest.isEmptyOrWhitespace:
    return "Skip"
  let oldSource = source
  let oldDest = dest
  let source = getPath(source)
  var dest = getPath(dest)
  dest = addTail(source, dest)
  if dirExists(source) and dirExists(dest):
    overwriteDot(source, dest, oldSource, oldDest, 0)
  elif dirExists(source) and not dirExists(dest):
    setEchoColor("==> Copying " & oldSource & " to " & oldDest & "\n", fgBlue)
    copyDir(source, dest)
  elif fileExists(source) and not fileExists(dest):
    let destDir = splitPath(dest)
    if not dirExists(destDir.head):
      createDir(destDir.head)
    setEchoColor("==> Copying " & oldSource & " to " & oldDest & "\n", fgBlue)
    copyFile(source, dest)
  elif fileExists(source) and fileExists(dest):
    overwriteDot(source, dest, oldSource, oldDest, 1)
  else:
    setEchoColor("Directory or file does not exist.\n", fgRed)
  return "Done"
