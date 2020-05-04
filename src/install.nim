import osproc, distros, types, sync, sugar, sequtils

proc getNeeded(package: string): string =
  if detectOs(Manjaro) or detectOs(ArchLinux):
    return package & " --needed"
  else:
    return package

proc installPackages*(config: Conf): string =
  ## Install all packages defined in the configuration with the
  ## system's package manager
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
  ## Install all dotfiles defined in the configuration
  discard config.dotfiles.map(dot => copyDots(dot.local_path, dot.install_path))
  return "Dotfiles copied"
