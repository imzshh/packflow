Async = require 'async'
CoffeeScript = require 'coffee-script'
Fs = require 'fs'
Path = require 'path'
Util = require '../util'
StepProcessor = require '../step-processor'

__copyFile = (src, dst, callback) ->
  Util.ensureDirOfFileExistsSync dst

  srcStream = Fs.createReadStream src
  dstStream = Fs.createWriteStream dst

  handlerEnd = (err) ->
    callback err

  srcStream.on 'end', handlerEnd
  srcStream.on 'error', handlerEnd
  srcStream.pipe dstStream

class CopyFileStepProcessor extends StepProcessor
  processTask : (task, callback) ->
    inputFullName = Path.join task.inputPath, task.fileName
    outputFullName = Path.join task.outputPath, task.fileName

    console.log 'copy file: ' + inputFullName + ' -> ' + outputFullName
    @registerFileRead inputFullName
    __copyFile inputFullName, outputFullName, (err) ->
      if err then return callback err

      taskResult =
        outputPath : task.outputPath
        fileName : task.fileName
        fullName : outputFullName

      callback null, taskResult

module.exports = CopyFileStepProcessor

