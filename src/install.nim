import osproc, distros

proc installPackage*(package: string): string =
  let (cmd, root) = foreignDepInstallCmd(package)
  if root==true:
    if (execCmd("sudo " & cmd) == 1):
      echo("sudo ", cmd, " command failed with exit code: ", 1)
  else:
    if (execCmd(cmd) == 1):
      echo(cmd, " command failed with exit code: ", 1)
  return package
#For testing purposes will remove later
when isMainModule:
  #installPackage("emacs")
  echo(foreignDepInstallCmd("neovim emacs"))
