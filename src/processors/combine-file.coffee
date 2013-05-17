Async = require 'async'
Fs = require 'fs'
Path = require 'path'
Less = require 'less'
Util = require '../util'
StepProcessor = require '../step-processor'

class CombineFileStepProcessor extends StepProcessor
  process : (input, callback) ->
    output = []
    basePath = @_packer.getBasePath()
    inputPath = Path.join basePath, @_step.inputPath || ''
    outputPath = Path.join basePath, @_step.outputPath || ''
    writeFile = @_step.writeFile
    options = @_step.options

    inputFileNameFormat = @_step.inputFileNameFormat

    for outputFileName, inputFileNames of @_step.files
      combinedContent = ''

      for inputFileName in inputFileNames
        if inputFileNameFormat
          inputFileName = inputFileNameFormat.replace '${fileName}', inputFileName

        inputFullName = Path.join inputPath, inputFileName
        @registerFileRead inputFullName
        combinedContent += Fs.readFileSync(inputFullName, 'utf-8') + '\n'

      if writeFile
        formatedOutputFileName = outputFileName
        outputFileNameFormat = @_step.outputFileNameFormat
        if outputFileNameFormat
          formatedOutputFileName = outputFileNameFormat.replace '${fileName}', outputFileName
        outputFullName = Path.join outputPath, formatedOutputFileName
        Util.ensureDirOfFileExistsSync outputFullName
        Fs.writeFileSync outputFullName, combinedContent
      
      taskResult =
        outputPath : outputPath
        fileName : outputFileName
        outputFullName : outputFullName
        content : combinedContent
      output.push taskResult
  
    callback null, output

module.exports = CombineFileStepProcessor

