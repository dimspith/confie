import os, strutils

proc getPath(path: string): string =
  if path.startsWith("~"):
    return expandTilde(path)
  else:
    return absolutePath(path)

proc overwriteDot(source, dest, oldSource, oldDest: string, ftype: int) =
  while true:
    echo("Do you want to overwrite already existing file/directory?(y/n)")
    let answer = stdin.readLine()
    if answer == "y" or answer == "yes" or answer == "Y":
      echo("Copying ", oldSource, " to ", oldDest)
      if ftype == 0:
        copyDir(source, dest)
      elif ftype == 1:
        copyFile(source, dest)
      else:
        echo("Not a file or directory.")
      return
    elif answer == "n" or answer == "no" or answer == "N":
      echo("Skipping ", oldSource)
      return

func addTail(source, dest: string): string =
  let sourcePath = splitPath(source)
  let destPath = splitPath(dest)
  if destPath.tail == sourcePath.tail:
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
    echo("Copying ", oldSource, " to ", oldDest)
    copyDir(source, dest)
  elif fileExists(source) and not fileExists(dest):
    echo("Copying ", oldSource, " to ", oldDest)
    copyFile(source, dest)
  elif fileExists(source) and fileExists(dest):
    overwriteDot(source, dest, oldSource, oldDest, 1)
  else:
    echo "Directory or file does not exist."
  return "Done"
