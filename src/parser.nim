import parsecfg, types, tables, sugar

proc parseConfig*(location: string): string =
  ## Parse the toml config file and fill the required variables
  try:
    let cfg = loadConfig(location)
    var conf = Conf(
      dotfiles: @[],
      packages: @[]
    )
    for section, key in cfg.pairs:
      let dotfile = Dotfile(
        name: section,
        local_path: key.getOrDefault("local_path"),
        install_path: key.getOrDefault("install_path")
      )
      conf.dotfiles.add(dotfile)
  except IOError:
    return "Invalid filename"

when isMainModule:
  echo parseConfig("confie.cfg")
  echo parseConfig("qq.cfg")
