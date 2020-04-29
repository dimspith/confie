import parsetoml

proc parseTOMLFile*(location: string): string =
  ## Parse the toml config file and fill the required variables
  let tomlTable = parseToml.parseFile(location)
  return tomlTable.toTomlString

when isMainModule:
  let s = parseTOMLFile("config.toml")
