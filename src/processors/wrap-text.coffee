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

class WrapTextStepProcessor extends StepProcessor
  processTask : (task, callback) ->
    if task.content
      fileContent = task.content
    else
      inputFullName = Path.join task.inputPath, task.fileName
      fileContent = Fs.readFileSync inputFullName, 'utf-8'

    options = task.options
    prefix = options.prefix || ''
    suffix = options.suffix || ''
    wrapedContent = prefix + fileContent + suffix

    if not task.outputFileNameFormat
      outputFileName = task.fileName
    else
      outputFileName = task.outputFileNameFormat.replace '${fileName}', task.fileName
    outputFullName = Path.join task.outputPath, outputFileName

    if task.writeFile
      Util.ensureDirOfFileExistsSync outputFullName
      Fs.writeFileSync outputFullName, wrapedContent

    taskResult =
      outputPath : task.outputPath
      fileName : task.fileName
      outputFullName : outputFullName
      content : wrapedContent

    callback null, taskResult

module.exports = WrapTextStepProcessor

