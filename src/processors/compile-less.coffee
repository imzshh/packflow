Async = require 'async'
Fs = require 'fs'
Path = require 'path'
Less = require 'less'
Util = require '../util'
StepProcessor = require '../step-processor'

__compileLess = (data, fileName, callback) ->
  new Less.Parser
    paths : [Path.dirname fileName]
    filename : fileName
  .parse data, (err, tree) ->
    if err then return callback err

    try
      css = tree.toCSS
        compress : true
    catch err
      callback new Error 'compile less error: ' + err.message

    callback null, css

class CompileLessStepProcessor extends StepProcessor
  processTask : (task, callback) ->
    inputFullName = Path.join task.inputPath, task.fileName + '.less'
    if task.content
      fileContent = task.content
    else
      @registerFileRead inputFullName
      fileContent = Fs.readFileSync inputFullName, 'utf-8'

    __compileLess fileContent, inputFullName, (err, compiledContent) ->
      if err then return callback err

      outputFullName = Path.join task.outputPath, task.fileName + '.css'

      if task.writeFile
        Util.ensureDirOfFileExistsSync outputFullName
        Fs.writeFileSync outputFullName, compiledContent

      taskResult =
        outputPath : task.outputPath
        fileName : task.fileName
        fullName : outputFullName
        content : compiledContent

      callback null, taskResult

module.exports = CompileLessStepProcessor

