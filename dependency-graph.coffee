_ = require 'lodash'

Key =
  Substructure: "key.substructure"
  Kind: "key.kind"
  InheritedTypes: "key.inheritedtypes"
  Name: "key.name"

DeclarationType =
  Protocol: "source.lang.swift.decl.protocol"

analyzer = (json) ->

  protocols = []
  protocolsAndParents = {}

  parseEntry = (entry) ->
    for filename, subentry of entry
      parseSubentry subentry[Key.Substructure] if subentry[Key.Substructure]

  parseSubentry = (structures) ->
    for structure in structures
      parseSubentry structure[Key.Substructure] if structure[Key.Substructure]
      if structure[Key.Kind] is DeclarationType.Protocol
        protocols.push structure

  for entry in json
    parseEntry entry

  parseProtocol = (protocol) ->
    if protocol[Key.InheritedTypes]?
      parents = _.map protocol[Key.InheritedTypes], Key.Name
      protocolsAndParents[protocol[Key.Name]] = parents

  for protocol in protocols
    parseProtocol protocol

  return protocolsAndParents

dotGraph = (json) ->
  protocolsAndParents = analyzer json
  dotLines = ['digraph dependencies_diagram {']
  print = (source, targets) ->
    for target in targets
      dotLines.push "#{source} -> #{target};"
  for source, targets of protocolsAndParents
    print source, targets
  dotLines.push '}'

  return dotLines.join '\n'

# TODO: Add usage info
console.log dotGraph require "./#{process.argv[2]}"