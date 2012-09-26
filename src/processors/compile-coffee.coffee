CoffeeScript = require 'coffee-script'
Fs = require 'fs'
Path = require 'path'
Util = require '../util'
StepProcessor = require '../step-processor'

class CompileCoffeeStepProcessor extends StepProcessor
  processTask : (task, callback) ->
    if task.content
      fileContent = task.content
    else
      inputFullName = Path.join task.inputPath, task.fileName + '.coffee'
      @registerFileRead inputFullName
      fileContent = Fs.readFileSync inputFullName, 'utf-8'

    bare = task.options && task.options.bare

    try
      compiledContent = CoffeeScript.compile fileContent, bare : bare
    catch err
      callback new Error 'compile coffee error: ' + err.message

    outputFullName = Path.join task.outputPath, task.fileName + '.js'

    if task.writeFile
      Util.ensureDirOfFileExistsSync outputFullName
      Fs.writeFileSync outputFullName, compiledContent

    taskResult =
      outputPath : task.outputPath
      fileName : task.fileName
      outputFullName : outputFullName
      content : compiledContent

    callback null, taskResult

module.exports = CompileCoffeeStepProcessor

