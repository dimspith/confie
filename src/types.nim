type
  Dotfile = object
    name: string
    local_path: string
    install_path: string

  Conf* = object
    package_list: seq[string]
    dotfiles: seq[Dotfile]

