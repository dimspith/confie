import osproc, distros

proc getNeeded(package: string): string =
  if detectOs(Manjaro) or detectOs(ArchLinux):
    return package & " --needed"
  else:
    return package

proc installPackage*(package: string) =
  let (installCmd, root) = foreignDepInstallCmd(package)
  let cmd = getNeeded(installCmd)
  if root == true:
    if (execCmd("sudo " & cmd) == 1):
      echo("sudo ", cmd, " command failed with exit code: ", 1)
  else:
    if (execCmd(cmd) == 1):
      echo(cmd, " command failed with exit code: ", 1)
#For testing purposes will remove later
when isMainModule:
  installPackage("emacs neovim alacritty")
