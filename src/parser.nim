import parsetoml

proc parseTOMLFile*(location: TaintedString): string =
  ## Parse the toml config file and fill the required variables
  let tomlTable = parseToml.parseFile(location)
  return tomlTable.toTomlString

