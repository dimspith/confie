import osproc, distros, types, sync, sugar, sequtils, strutils

proc getNeeded(package: string): string =
  if detectOs(Manjaro) or detectOs(ArchLinux):
    return package & " --needed"
  else:
    return package

proc installPackages*(config: Conf): string =
  ## Install all packages defined in the configuration with the
  ## system's package manager
  if (getPackagesString(config).isEmptyOrWhitespace()):
    return "Packages section is empty or not declared correctly"
  let (installCmd, root) =
    foreignDepInstallCmd(getPackagesString(config))
  let cmd = getNeeded(installCmd)
  if root == true:
    if (execCmd("sudo " & cmd) == 1):
      return "Installation failed"
  else:
    if (execCmd(cmd) == 1):
      return "Installation failed"
  return "Packages installed"

proc verify(): string =
  while true:
    echo("Proceed with copy?(y/n)")
    let answer = stdin.readLine()
    if answer == "y" or answer == "yes" or answer == "Y":
      return "Continue"
    elif answer == "n" or answer == "no" or answer == "N":
      return "Abort"

proc installDotfiles*(config: Conf): string =
  ## Install all dotfiles defined in the configuration
  if verify() == "Abort":
    return "Abort"
  else:
    discard config.dotfiles.map(dot => copyDots(dot.local_path, dot.install_path))
    return "Dotfiles copied"

proc fetchDotfiles*(config: Conf): string =
  ## Fetches all dotfiles defined in the configuration
  if verify() == "Abort":
    return "Abort"
  else:
    discard config.dotfiles.map(dot => copyDots(dot.install_path, dot.local_path))
    return "Dotfiles copied"
