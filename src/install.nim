import osproc, distros, types, sync, strutils, colorize

proc appendArgs(package: string): string =
  ## Append arguments to the installation command of each distro
  ## that make the process easier.
  if detectOs(Manjaro) or detectOs(ArchLinux):
    return package & " --needed"
  else:
    return ""


proc installPackages*(config: Conf) =
  ## Install all packages defined in the configuration with the
  ## system's package manager.

  if (getPackagesString(config).isEmptyOrWhitespace()):
    quit("Error: ".fgRed & "Packages section is empty or not declared correctly.", QuitFailure)

  let
      (installCmd, root) = foreignDepInstallCmd(getPackagesString(config))
      cmd = appendArgs(installCmd)

  if cmd.isEmptyOrWhitespace():
    echo("Error: ".fgYellow & "Can't find your distribution's package manager")
    stdout.write("Prompt: ".fgRed & "Please insert installation command (e.g 'sudo apt install'): ")
    let newcmd = stdin.readLine() & " " & getPackagesString(config)
    
    echo("Info:".fgCyan, "The following command will be executed:")
    echo newcmd
    if(verify("Prompt: ".fgYellow & "Proceed? (y/n): ")):
      if(execCmd(newcmd) == 1):
        quit("Error: ".fgRed & "Installation failed.", QuitFailure)
    else:
      quit("Error: ".fgRed & "Aborted.", QuitFailure)
      
  if root == true:
    if (execCmd("sudo " & cmd) == 1):
      quit("Error: ".fgRed & "Installation failed.", QuitFailure)
  else:
    if (execCmd(cmd) == 1):
      quit("Error: ".fgRed & "Installation failed.", QuitFailure)

  quit("Success: ".fgGreen & "Packages installed successfully.", QuitSuccess)


proc installDotfiles*(config: Conf, reverse: bool) =
  ## Install all dotfiles defined in the configuration `config`.
  ## If `reverse` is true, dotfiles are fetched from the system.
  echo printDotfiles(config)
  if verify("Prompt: ".fgYellow & "Proceed moving dotfiles? (y/n) ") == false:
    quit("Error: ".fgRed & "Aborted.", QuitFailure)
  else:
    if reverse:
      for dot in config.dotfiles:
        copyDots(dot.install_path, dot.local_path)
    else:
      for dot in config.dotfiles:
        copyDots(dot.install_path, dot.local_path)
  quit("Success: ".fgGreen & "Dotfiles copied.", QuitSuccess)
