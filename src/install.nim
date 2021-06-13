import osproc, distros, types, sync, sugar, sequtils, strutils, colorize

proc verify(message: string): bool =
  while true:
    stdout.write(message)
    let answer = stdin.readLine()
    case answer:
      of "y", "yes", "Y":
        return true
      else:
        return false

proc getNeeded(package: string): string =
  if detectOs(Manjaro) or detectOs(ArchLinux):
    return package & " --needed"
  else:
    return ""

proc installPackages*(config: Conf): string =
  ## Install all packages defined in the configuration with the
  ## system's package manager

  if (getPackagesString(config).isEmptyOrWhitespace()):
    return "Error: ".fgRed & "Packages section is empty or not declared correctly."

  let
      (installCmd, root) = foreignDepInstallCmd(getPackagesString(config))
      cmd = getNeeded(installCmd)

  if cmd.isEmptyOrWhitespace(): return "Error: ".fgRed & "Unsupported distro, aborting..."
  if root == true:
    if (execCmd("sudo " & cmd) == 1):
      return "Error: ".fgRed & "Installation failed."
  else:
    if (execCmd(cmd) == 1):
      return "Error: ".fgRed & "Installation failed."
  return "Success: ".fgGreen & "Packages installed successfully."

proc installDotfiles*(config: Conf): string =
  ## Install all dotfiles defined in the configuration
  echo printDotfiles(config)
  if verify("Prompt: ".fgYellow & "Proceed copying dotfiles? (y/n) ") == false:
    return "Error: ".fgRed & "Aborted."
  else:
    discard config.dotfiles.map(dot => copyDots(dot.local_path, dot.install_path))
    return "Success: ".fgGreen & "Dotfiles copied."

proc fetchDotfiles*(config: Conf): string =
  ## Fetches all dotfiles defined in the configuration
  if verify("Prompt: ".fgYellow & "Proceed fetching dotfiles? (y/n)") == false:
    return "Error: ".fgRed & "Aborted."
  else:
    discard config.dotfiles.map(dot => copyDots(dot.install_path, dot.local_path))
    return "Success: ".fgGreen & "Dotfiles copied."
