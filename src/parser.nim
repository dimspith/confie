import parsecfg, types, tables, sugar, install, sequtils

proc parseConfig*(location: string) =
  ## Parse the toml config file and fill the required variables
  try:
    let cfg = loadConfig(location)
    var conf = Conf(
      dotfiles: @[],
      packages: @[]
    )
    for section, key in cfg.pairs:
      if section=="":
        conf.newPackages(key.getOrDefault("packages"))
        #echo(conf.packages)
        continue
      let dotfile = Dotfile(
        name: section,
        local_path: key.getOrDefault("local_path"),
        install_path: key.getOrDefault("install_path")
      )
      conf.dotfiles.add(dotfile)
      #echo(conf.dotfiles)
    discard conf.packages.map(pack => installPackage(pack))
  except IOError:
    echo "File not found"

#For testing purposes will remove later
when isMainModule:
  parseConfig("confie.cfg")
  parseConfig("qq.cfg")
