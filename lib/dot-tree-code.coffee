_ = require 'lodash'
analyzer = require './analyzer.coffee'
handlebars = require 'handlebars'
fs = require 'fs'
path = require 'path'
Constants = require './constants.coffee'

legendPath = path.resolve __dirname, '../assets/legend.template'
legendSource = fs.readFileSync legendPath
legendTemplate = handlebars.compile legendSource.toString()

clustersPath = path.resolve __dirname, '../assets/clusters.template'
clustersSource = fs.readFileSync clustersPath
clustersTemplate = handlebars.compile clustersSource.toString()

dotGraphPath = path.resolve __dirname, '../assets/dotGraph.template'
dotGraphSource = fs.readFileSync dotGraphPath
dotGraphTemplate = handlebars.compile dotGraphSource.toString()

module.exports = (json, root) ->

  analysis = analyzer json

  graph =
    protocols:
      color: Constants.Style.Protocols.Color
      shape: Constants.Style.Protocols.Shape
      data: analysis.protocols
    structs:
      color: Constants.Style.Structs.Color
      shape: Constants.Style.Structs.Shape
      data: analysis.structs
    classes:
      color: Constants.Style.Classes.Color
      shape: Constants.Style.Classes.Shape
      data: analysis.classes
    system:
      color: Constants.Style.System.Color
      shape: Constants.Style.System.Shape
      data: []

  entities = {}
  for type, typeInfo of graph
    for name, parents of typeInfo.data
      entities[name] =
        color: typeInfo.color
        shape: typeInfo.shape
        parents: parents
        relatedWithRoot: name is root

  # Mark descendant objects as related.
  needsToCheckEntitiesAgain = true
  while needsToCheckEntitiesAgain
    needsToCheckEntitiesAgain = false
    for entity, info of entities
      for parent in info.parents
        unless entities[parent]?
          entities[parent] =
            color: Constants.Style.System.Color
            shape: Constants.Style.System.Shape
            parents: []
            relatedWithRoot: parent is root
        if not info.relatedWithRoot and entities[parent].relatedWithRoot
          info.relatedWithRoot = entities[parent].relatedWithRoot
          needsToCheckEntitiesAgain = true

  # Mark ancestor objects as related.
  needsToCheckEntitiesAgain = true
  while needsToCheckEntitiesAgain
    needsToCheckEntitiesAgain = false
    for entity, info of entities
      for parent in info.parents
        if info.relatedWithRoot and not entities[parent].relatedWithRoot
          entities[parent].relatedWithRoot = info.relatedWithRoot
          needsToCheckEntitiesAgain = true

  cluster =
    number: 0
    entities: []
    relationships: []

  for entity, info of entities
    delete entities[entity] unless info.relatedWithRoot

  for entity, info of entities
    cluster.entities.push {
      name: entity
      color: info.color
      shape: info.shape
    }
    for parent in info.parents
      if entities[parent]?
        cluster.relationships.push {
          source: entity
          target: parent
        }

  clusters = clustersTemplate { clusters: [cluster] }

  legend = legendTemplate graph

  dotLines = ['digraph dependencies_diagram {']

  return dotGraphTemplate {
    clusters: clusters
    legend: legend
  }
