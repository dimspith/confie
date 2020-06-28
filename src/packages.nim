## Utilities for installing packages

import osproc, distros, types, strutils, terminal
import util

# Cache the result of "uname -a" for detecting distributions that are missing from the "distros" library
var unameRes: string
template unameRelease(cmd, cache): untyped =
  if cache.len == 0:
    cache = (when defined(nimscript): gorge(cmd) else: execProcess(cmd))
  cache
template uname(): untyped = unameRelease("uname -a", unameRes)

proc getOrRequestPMCmd(packages: string): string =
  ## If the distro is specified in the "distros" library, 
  let (cmd, root) = foreignDepInstallCmd(packages)
  if "<your package manager here>" in cmd:
    setEchoColor(
      "==> Unknown distribution, please type your package manager's installation command (i.e sudo apt install):\n"
      , fgRed)
    setEchoColor("==> ", fgRed)
    let answer = stdin.readLine()
    if answer.isEmptyOrWhitespace:
      return ""
    return answer & " " & packages
  elif root:
    return "sudo " & cmd
  else:
    return cmd

proc getPMCommand(packages: string): string =
  ## Get the command that installs specified packages with the distro's package manager.
  ## If it can't be found, prompt the user for the command or abort installation if empty.
  if detectOs(Manjaro) or detectOs(ArchLinux):
    return "sudo pacman -S --needed " & packages
  elif "void" in uname():
    return "sudo xbps-install " & packages
  else:
    return getOrRequestPMCmd(packages)

proc installPackages*(config: Conf): string =
  ## Install all packages defined in the configuration with the system's package manager
  if (getPackagesString(config).isEmptyOrWhitespace()):
    return "Packages section is empty or not declared correctly"
  let pmCommand = getPMCommand(getPackagesString(config))
  if pmCommand.isEmptyOrWhitespace:
    return "Package installation aborted!"
  elif (execCmd(pmCommand) == 1):
      return "Package installation failed!"
  else:
    return "Packages installed successfully!"
