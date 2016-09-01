require 'colors'
_ = require 'lodash'
Bluebird = require 'bluebird'
fs = Bluebird.promisifyAll require 'fs'

Key =
  Substructure: "key.substructure"
  Kind: "key.kind"
  InheritedTypes: "key.inheritedtypes"
  Name: "key.name"

DeclarationType =
  Protocol: "source.lang.swift.decl.protocol"
  Struct: "source.lang.swift.decl.struct"
  Class: "source.lang.swift.decl.class"

analyzer = (json) ->

  protocols = []
  structs = []
  classes = []

  protocolsAndParents = {}
  structsAndParents = {}
  classesAndParents = {}

  parseEntry = (entry) ->
    for filename, subentry of entry
      parseSubentry subentry[Key.Substructure] if subentry[Key.Substructure]

  parseSubentry = (structures) ->

    KindHandlers =
      "#{DeclarationType.Protocol}": (structure) -> protocols.push structure
      "#{DeclarationType.Struct}": (structure) -> structs.push structure
      "#{DeclarationType.Class}": (structure) -> classes.push structure

    for structure in structures
      parseSubentry structure[Key.Substructure] if structure[Key.Substructure]
      KindHandlers[structure[Key.Kind]]? structure

  for entry in json
    parseEntry entry

  parseEntity = (entity, type) ->

    TypeHandlers =
      "#{DeclarationType.Protocol}": (n, p) -> protocolsAndParents[n] = p
      "#{DeclarationType.Struct}": (n, p) -> structsAndParents[n] = p
      "#{DeclarationType.Class}": (n, p) -> classesAndParents[n] = p

    if entity[Key.InheritedTypes]?

      parents = _.map entity[Key.InheritedTypes], (entry) ->

        name = _.trim entry[Key.Name]
        match = /^([^<]*)(?:<.*>)?$/gi.exec name
        name = _.nth match, 1

        return name

      TypeHandlers[type]? entity[Key.Name], parents

  for protocol in protocols
    parseEntity protocol, DeclarationType.Protocol

  for struct in structs
    parseEntity struct, DeclarationType.Struct

  for klass in classes
    parseEntity klass, DeclarationType.Class

  return {
    protocols: protocolsAndParents
    structs: structsAndParents
    classes: classesAndParents
  }

dotGraph = (json, types) ->

  analysis = analyzer json

  graph =
    protocols:
      color: "blue"
      data: analysis.protocols
    structs:
      color: "red"
      data: analysis.structs
    classes:
      color: "green"
      data: analysis.classes

  if _.isString types
    types = type.split ','

  if _.isArray types
    keys = Object.keys graph
    for key in keys
      if key not in types
        delete graph[key]

  dotLines = ['digraph dependencies_diagram {']

  print = (source, targets, color) ->
    dotLines.push "\"#{source}\" [shape=box color=#{color}];"
    for target in targets
      dotLines.push "\"#{source}\" -> \"#{target}\";"

  printColoredData = (color, data) ->
    for source, targets of data
      print source, targets, color

  for key, entry of graph
    printColoredData entry.color, entry.data

  dotLines.push '}'

  return dotLines.join '\n'

availableOperations =
  dotGraph: dotGraph

fileName = process.argv[2]
operation = process.argv[3] ? _.first Object.keys availableOperations
type = process.argv[4]

if process.argv.length < 3 or operation not in Object.keys availableOperations
  console.log "Usage: ./dependency-graph.sh
    #{'<filename>'.magenta}
    #{'[<operation>, <type>]'.yellow}"
  console.log ''

  ops = ( "#{key.blue}" for key, value of availableOperations ).join ', '

  console.log "Available #{'<operation>'.yellow}s: #{ops}"
  process.exit 1

fs.readFileAsync( fileName )
  .then (data) ->
    return JSON.parse data.toString()
  .then (json) ->

    console.log availableOperations[operation] json, type

  .caught (error) ->
    console.error error
    process.exit 1
