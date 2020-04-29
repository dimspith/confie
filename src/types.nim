type
  Dotfile = object
    name: string
    local_path: string
    install_path: string

type
  Conf* = object
    dotfiles: seq[Dotfile]
    packages: seq[string]
      

