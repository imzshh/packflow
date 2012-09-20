__getStepProcessor = (packer, step) ->
  processorCls = require './processors/' + step.type
  new processorCls packer, step

class Packer
  constructor : (project, basePath) ->
    @_project = project
    @_basePath = basePath || process.cwd()
    @clean()

  clean : ->
    @_stepResult = {}
    @_filesRead = []

  processStep : (stepName, input, callback) ->
    result = @_stepResult[stepName]
    if result then return callback null, result

    step = @_project.steps[stepName]
    if not step then return callback new Error 'StepNotFound: ' + stepName

    stepProcessor = __getStepProcessor this, step

    console.log "processing step: " + stepName
    stepProcessor.process input, (err, result) =>
      if err then return callback err

      @_stepResult[stepName] = result
      callback null, result

  getProject : ->
    @_project

  getBasePath : ->
    @_basePath

  getFilesRead : ->
    @_filesRead

  registerFileRead : (filePath) ->
    @_filesRead.push filePath

module.exports = Packer
  

