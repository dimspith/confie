import parsecfg, tables, strutils, os, colorize
import types

func parseConfig*(cfg: Config): Conf =
  ## Parse the configuration and generate a Conf type
  var conf = Conf()
  for section, key in cfg.pairs:
    if not section.isEmptyOrWhitespace:
      let dotfile = Dotfile(
        name: section,
        local_path: key.getOrDefault("local_path"),
        install_path: key.getOrDefault("install_path"))
      conf = conf.appendDotfile(dotfile)
    else:
      conf = conf.setPackages(key.getOrDefault("packages"))
  return conf

proc parseFileOrDir*(location: string): tuple[error: string, config: Conf] =
  ## Check if the configuration file exists or if a directory is supplied,
  ## check if it's contained inside. Returns a tuple containing an error string
  ## and the parsed configuration if no error was encountered

  if fileExists location:
    let config = parseConfig(loadConfig(location))
    return ("", config)
  elif dirExists location:
    if fileExists (location / "confie.cfg"):
      let config = parseConfig(loadConfig(location / "confie.cfg"))
      return ("", config)
    else:
      return ("Error: ".fgRed & "Directory does not contain a confie.cfg file.", Conf())
  else:
    return ("Error: ".fgRed & "Invalid file or directory.", Conf())
