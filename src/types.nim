import sugar, sequtils, strutils

type
  Dotfile* = object
    name*: string
    local_path*: string
    install_path*: string

type
  Conf* = object
    dotfiles*: seq[Dotfile]
    packages*: seq[string]

let sampleConfig*: Conf = Conf(dotfiles:
  @[
    Dotfile(name: "nvim", local_path: "nvim/", install_path: "~/.config/nvim"),
    Dotfile(name: "emacs", local_path: "emacs/", install_path: "~/.emacs.d/")
  ], packages: @["emacs", "nvim"])

proc getAllDotfileNames*(config: Conf): seq[string] =
  return config.dotfiles.map(x => x.name)

proc getField*(config: Conf, name: string, field: string): string =
  case field:
    of "name":
      return config.dotfiles.filter(x => x.name == name)[0].name
    of "local_path":
      return config.dotfiles.filter(x => x.name == name)[0].local_path
    of "install_path":
      return config.dotfiles.filter(x => x.name == name)[0].install_path

proc newPackages*(packages: string): seq[string] =
  return packages.unindent.splitLines.toSeq
