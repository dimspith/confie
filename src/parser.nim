import parsecfg, types, tables, install, sequtils

proc parseConfig*(location: string): Conf =
  ## Parse the toml config file and fill the required variables
  try:
    let cfg = loadConfig(location)
    var conf = Conf(
      dotfiles: @[],
      packages: @[]
    )
    for section, key in cfg.pairs:
      if section == "":
        conf.packages = newPackages(key.getOrDefault("packages"))
        #echo(conf.packages)
        continue
      let dotfile = Dotfile(
        name: section,
        local_path: key.getOrDefault("local_path"),
        install_path: key.getOrDefault("install_path")
      )
      conf.dotfiles.add(dotfile)
      #echo(conf.dotfiles)
    let packages = conf.packages.foldl(a & " " & b)
    installPackage(packages)
    return conf
  except IOError:
    echo "File not found"

#For testing purposes will remove later
when isMainModule:
  parseConfig("confie.cfg")
  parseConfig("qq.cfg")
