Async = require 'async'
Path = require 'path'

class StepProcessor
  constructor : (packer, step) ->
    @_packer = packer
    @_step = step

  process : (input, callback) ->
    output = []
    basePath = @_packer.getBasePath()
    inputPath = Path.join basePath, @_step.inputPath
    outputPath = Path.join basePath, @_step.outputPath
    outputFileName = @_step.outputFileName
    options = @_step.options

    Async.series [ (callback) =>
      if not input or input.length is 0 then return callback()

      Async.forEachSeries input, (inputTaskResult, callback) =>
        task =
          inputPath : inputTaskResult.inputPath
          outputPath : outputPath
          fileName : inputTaskResult.fileName
          outputFileName : outputFileName
          options : options
          content : inputTaskResult.content

        @processTask task, (err, result) ->
          if err then return callback err

          if result then output.push result
          callback()
        
      , callback

    , (callback) =>
      files = @_step.files
      if not files or files.length is 0 then return callback()

      Async.forEachSeries files, (fileName, callback) =>
        task =
          inputPath : inputPath
          outputPath : outputPath
          fileName : fileName
          outputFileName : outputFileName
          options : options

        @processTask task, (err, result) ->
          if err then return callback err

          if result then output.push result
          callback()

      , callback
    
    ], (err) ->
      if err then return callabck err

      callback null, output

module.exports = StepProcessor