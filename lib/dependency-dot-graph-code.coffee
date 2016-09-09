_ = require 'lodash'
analyzer = require './analyzer.coffee'

module.exports = (json, types) ->

  analysis = analyzer json

  graph =
    protocols:
      color: 'blue'
      data: analysis.protocols
    structs:
      color: 'red'
      data: analysis.structs
    classes:
      color: 'green'
      data: analysis.classes

  if _.isString types
    types = types.split ','

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
