import os, strutils, colorize

proc verify*(message: string): bool =
  ## Prints `message` to stdout and waits for user input.
  ## returns `true` if the answer is yes or empty, or `false` otherwise.
  stdout.write(message)
  let answer = stdin.readLine()
  case answer:
    of "y", "Y", "yes", "":
      return true
    else:
      return false


proc getPath(path: string): string =
  ## Returns the absolute path of `path` or expands `~` and `~/` if they exist.
  if path.startsWith("~"):
    return expandTilde(path)
  else:
    return absolutePath(path)


func addTail(source, dest: string): string =
  ## Add filename from source path to
  ## destination path if not supplied.
  
  let
    sourcePath = splitPath(source)
    destPath = splitPath(dest)

  if destPath.tail == sourcePath.tail:
    return dest
  else:
    return dest/sourcePath.tail


proc copyDot(source, dest, oldSource, oldDest: string, ftype: int, conflict: bool) =
  ## Copies a file/folder from `source` to `dest`.
  ## If there is already a file in `dest`, prompt user
  ## to decide if it should be overwritten.
  
  let answer = (
    if conflict:
      verify("Prompt: ".fgYellow & "Overwrite " & oldDest.fgMagenta & " with " & oldSource.fgMagenta & " (y/n) ")
    else: true)

  case answer:
    of true:
      echo("Info: ".fgCyan, "Copying ", oldSource, " to ", oldDest)
      if ftype == 0:
        copyDir(source, dest)
      elif ftype == 1:
        copyFile(source, dest)
      else:
        echo("Error: ".fgRed, "Not a file or directory.")
    else:
      echo("Info: ".fgCyan ,"Skipping ", oldSource)


proc copyDots*(source, dest: string) =
  ## Copy dotfiles form `source` to `dest`
  
  if source.isEmptyOrWhitespace or dest.isEmptyOrWhitespace:
    return

  let
    fullSource = getPath(source)
    fullDest = addTail(source, getPath(dest))

  if dirExists(source) and dirExists(dest):
    copyDot(fullSource, fullDest, source, dest, 0, true)
  elif dirExists(source) and not dirExists(dest):
    copyDot(fullSource, fullDest, source, dest, 0, false)
  elif fileExists(source) and not fileExists(dest):
    copyDot(fullSource, fullDest, source, dest, 0, false)
  elif fileExists(source) and fileExists(dest):
    copyDot(fullSource, fullDest, source, dest, 1, true)
  else:
    echo "Error: ".fgRed, "Directory or file does not exist."
