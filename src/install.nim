import osproc, distros, types

proc getNeeded(package: string): string =
  if detectOs(Manjaro) or detectOs(ArchLinux):
    return package & " --needed"
  else:
    return package

proc installPackages*(config: Conf): string =
  let (installCmd, root) =
    foreignDepInstallCmd(getPackagesString(config))
  let cmd = getNeeded(installCmd)
  if root == true:
    if (execCmd("sudo " & cmd) == 1):
      return "sudo " & cmd & " command failed"
  else:
    if (execCmd(cmd) == 1):
      return cmd & " command failed"

proc installDotfiles*(config: Conf): string =
  echo "Not supported yet!"
