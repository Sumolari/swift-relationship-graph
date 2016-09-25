_ = require 'lodash'
analyzer = require './analyzer.coffee'
handlebars = require 'handlebars'
fs = require 'fs'
path = require 'path'

legendPath = path.resolve __dirname, '../assets/legend.template'
legendSource = fs.readFileSync legendPath
legendTemplate = handlebars.compile legendSource.toString()

clustersPath = path.resolve __dirname, '../assets/clusters.template'
clustersSource = fs.readFileSync clustersPath
clustersTemplate = handlebars.compile clustersSource.toString()

dotGraphPath = path.resolve __dirname, '../assets/dotGraph.template'
dotGraphSource = fs.readFileSync dotGraphPath
dotGraphTemplate = handlebars.compile dotGraphSource.toString()

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
        graph[key].data = []

  entities = {}
  for type, typeInfo of graph
    color = typeInfo.color
    for name, parents of typeInfo.data
      entities[name] =
        color: color
        parents: parents
        cluster: Object.keys(entities).length

  for entity, info of entities
    for parent in info.parents
      unless entities[parent]?
        entities[parent] =
          color: 'black'
          parents: []
      originalCluster = entities[parent].cluster
      for other_entity, other_info of entities
        if entities[other_entity].cluster is originalCluster
          entities[other_entity].cluster = info.cluster

  clusters = {}
  for entity, info of entities
    unless clusters[info.cluster]
      clusters[info.cluster] =
        number: info.cluster
        entities: []
        relationships: []
    clusters[info.cluster].entities.push {
      name: entity
      color: info.color
    }
    for parent in info.parents
      clusters[info.cluster].relationships.push {
        source: entity
        target: parent
      }

  clusters = _.map clusters, (item) -> item

  clusters = clustersTemplate { clusters: clusters }

  legend = legendTemplate graph

  dotLines = ['digraph dependencies_diagram {']

  return dotGraphTemplate {
    clusters: clusters
    legend: legend
  }
