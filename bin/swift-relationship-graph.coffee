require 'colors'
_ = require 'lodash'
Bluebird = require 'bluebird'
fs = Bluebird.promisifyAll require 'fs'
os = require 'os'
path = require 'path'

Constants = require '../lib/constants.coffee'

availableOperations =
  dotGraphCode: (json,type) ->
    console.log require('../lib/dot-graph-code.coffee')(json, type)
  dotGraphPDF: require '../lib/dot-graph-pdf.coffee'
  graph: require '../lib/dot-graph-pdf.coffee'
  dotTreeCode: (json,type) ->
    console.log require('../lib/dot-tree-code.coffee')(json, type)
  dotTreePDF: require '../lib/dot-tree-pdf.coffee'
  tree: require '../lib/dot-tree-pdf.coffee'

defaultOperation = 'graph'
defaultType = _.first (v for key, v of Constants.SupportedTypes)

fileName = process.argv[2]
operation = process.argv[3] ? defaultOperation
types = process.argv[4] ? defaultType
outputFileName = process.argv[5]

if process.argv.length < 3 or operation not in Object.keys availableOperations
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

  process.exit 1

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
