require 'colors'
_ = require 'lodash'
Bluebird = require 'bluebird'
fs = Bluebird.promisifyAll require 'fs'
os = require 'os'
path = require 'path'
Constants = require '../lib/constants.coffee'

availableOperations =
  dotGraphCode: (json,type) ->
    console.log require('./dot-graph-code.coffee')(json, type)
  dotGraphPDF: require './dot-graph-pdf.coffee'
  graph: require './dot-graph-pdf.coffee'
  dotTreeCode: (json,type) ->
    console.log require('./dot-tree-code.coffee')(json, type)
  dotTreePDF: require './dot-tree-pdf.coffee'
  tree: require './dot-tree-pdf.coffee'

processParameters = (fileName, operation, types, outputFileName) ->

  defaultOperation = 'graph'
  defaultType = _.first (v for key, v of Constants.SupportedTypes)

  operation = defaultOperation unless operation?
  types = defaultType unless types?

  unless fileName? and operation in Object.keys availableOperations
    console.log "Usage: swift-relationship-graph
      #{'<pathToJSON>'.magenta}
      #{'[<operation>, <type or root node...>, <pathToOutputFile>]'.yellow}"
    console.log ''

    ops = _.map availableOperations, (value, key) ->
      if key is defaultOperation
        return "#{key}".underline.green
      return "#{key}".blue
    ops = ops.join ', '

    supportedTypes = _.map Constants.SupportedTypes, (value) ->
      if value is defaultType
        return "#{value}".underline.green
      return "#{value}".blue
    supportedTypes = supportedTypes.join ', '

    console.log "Available #{'<operation>'.yellow}s: #{ops}"
    console.log "Available #{'<type...>'.yellow}s (multiple values allowed,
                 comma separated): #{supportedTypes}"

    console.log ''

    return null

  return {
    fileName: fileName
    operation: operation
    types: types
    outputFileName: outputFileName
  }

run = (parameters) ->

  operation = parameters.operation
  types = parameters.type
  outputFileName = parameters.outputFileName
  fileName = parameters.fileName

  fileName = path.resolve './', fileName unless path.isAbsolute fileName

  fs.readFileAsync( fileName )
    .then (data) ->
      return JSON.parse data.toString()
    .then (json) ->
      availableOperations[operation] json, types, outputFileName
    .caught (error) ->

      console.error ''

      switch error.errno
        when -os.constants.errno.ENOENT
          console.error "#{"ERROR:".red} Couldn't open file #{fileName.magenta}"
        else
          console.error error

      console.error ''

      process.exit 1

module.exports =
  processParameters: processParameters
  run: run
