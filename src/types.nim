import strformat

type
  Packages = object
    package_manager: string
    package_list: seq[string]

  Dotfile = object
    name: string
    link: bool
    local_path: string
    install_path: string
    required_packages: seq[string]

  Config* = object
    packageConfig: Packages
    dotfiles: seq[Dotfile]

proc configString*(cfg: Config): string =
  return &"""
Packages:
  Package Manager: {cfg.package_manager}
  Package List: {cfg.package_list}

Dotfiles:
  
"""
