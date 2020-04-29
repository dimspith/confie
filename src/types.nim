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
