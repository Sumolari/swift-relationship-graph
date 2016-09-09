_ = require 'lodash'
generateCode = require './dependency-dot-graph-code.coffee'
Bluebird = require 'bluebird'
child_process = require 'child_process'
path = require 'path'

module.exports = (json, types, outputFilename) ->

  outputPath = outputFilename ? 'graph.pdf'
  outputPath = path.resolve './', outputPath unless path.isAbsolute outputPath

  dotCode = generateCode json, types

  return new Bluebird (resolve, reject) ->

    dot = child_process.spawn 'dot', ['-Tpdf', '-o', "#{outputPath}", '-Kdot']

    dot.stdout.pipe process.stdout

    dot.stdin.setEncoding 'utf-8'
    dot.stdin.on 'error', (error) ->
      console.error error

    dot.stdin.write dotCode
    dot.stdin.end()

    dot.on 'error', (error) ->
      console.error error
      reject error

    dot.on 'close', (code) ->
      return reject code if code isnt 0
      resolve()
