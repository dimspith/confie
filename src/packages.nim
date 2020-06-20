## Utilities for installing packages

import osproc, distros, types, strutils

proc getPMCommand(package: string): string =
  ## Gets the command to install specified packages with the system's package manager
  if detectOs(Manjaro) or detectOs(ArchLinux):
    return package & " --needed"
  else:
    return package

proc installPackages*(config: Conf): string =
  ## Install all packages defined in the configuration with the system's package manager
  if (getPackagesString(config).isEmptyOrWhitespace()):
    return "Packages section is empty or not declared correctly"
  let (installCmd, root) =
    foreignDepInstallCmd(getPackagesString(config))
  let cmd = getPMCommand(installCmd)
  if root == true:
    if (execCmd("sudo " & cmd) == 1):
      return "Installation failed"
  else:
    if (execCmd(cmd) == 1):
      return "Installation failed"
  return "Packages installed"
