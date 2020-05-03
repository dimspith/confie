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

func getAllDotfileNames*(config: Conf): seq[string] =
  ## Returns a list of all dotfile names defined in the configuration
  return config.dotfiles.map(x => x.name)

func stringsToSeq*(packages: string): seq[string] =
  ## Converts a multiline string into a sequence
  return packages.unindent.splitLines.toSeq

func appendDotfile*(conf: Conf, dot: Dotfile): Conf =
  ## Returns a new instance of the configuration with a dotfile added
  result = conf
  result.dotfiles.add(dot)

func setPackages*(conf: Conf, packages: string): Conf =
  ## Returns a new instance of the configuration with the package list filled
  result = conf
  result.packages = stringsToSeq packages

func getPackagesString*(conf: Conf): string =
  ## Fetches the package list from the configuration as one string
  conf.packages.foldl(a & " " & b)
