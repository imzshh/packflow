Fs = require 'fs'
Path = require 'path'
UglifyJS = require 'uglify-js'
Util = require '../util'
StepProcessor = require '../step-processor'

__doUglify = (source) ->
  {parser, uglify} = UglifyJS
  ast = parser.parse source
  ast = uglify.ast_mangle ast
  ast = uglify.ast_squeeze ast
  uglify.gen_code ast

class UglifyJSStepProcessor extends StepProcessor
  processTask : (task, callback) ->
    if task.content
      fileContent = task.content
    else
      inputFullName = Path.join task.inputPath, task.fileName + '.js'
      fileContent = Fs.readFileSync inputFullName, 'utf-8'

    uglifiedContent = __doUglify fileContent

    if not task.outputFileName
      outputFileName = task.fileName + '.js'
    else
      outputFileName = task.outputFileName.replace '${fileName}', task.fileName
    outputFullName = Path.join task.outputPath, outputFileName

    Util.ensureDirOfFileExistsSync outputFullName
    Fs.writeFileSync outputFullName, uglifiedContent

    taskResult =
      outputPath : task.outputPath
      fileName : task.fileName
      outputFullName : outputFullName
      content : uglifiedContent

    callback null, taskResult

module.exports = UglifyJSStepProcessor

