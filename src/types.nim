import sequtils, strutils, colorize, sugar

type
  Dotfile* = object
    name*: string
    local_path*: string
    install_path*: string

type
  Conf* = object
    dotfiles*: seq[Dotfile]
    packages*: seq[string]

func getPPDotfile*(dotfile: Dotfile, maxNameLen: int): string =
  ## Returns dotfile info in a pretty-printed format
  result.add(dotfile.name.fgCyan)
  for i in 0..(maxNameLen - dotfile.name.len):
    result.add(" ")
  result.add(": [" & dotfile.local_path & " -> " & dotfile.install_path & " ]\n")

func getMaxDotName*(dotfiles: seq[Dotfile]): int =
  ## Returns the length of the largest dotfile name
  return max(dotfiles.map((a) => a.name.len))

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

proc printConfig*(conf: Conf): string =
  ## Pretty print config

  let maxDotName: int = getMaxDotName(conf.dotfiles);

  result.add("Package List:\n".fgYellow.bold)
  result.add((getPackagesString conf) & "\n\n")
  result.add("Dotfiles:\n".fgMagenta.bold)
  result.add(conf.dotfiles.map((a) => getPPDotfile(a, maxDotName)).join())
