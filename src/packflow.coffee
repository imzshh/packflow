Packer = require './packer'
fs = require 'fs'
path = require 'path'
require 'coffee-script'

isPacking = false
fileChanged = false
fileWatched = false
packer = null

exports.run = ->
  program = require 'commander'
  program.version('0.3.1')
    .option('-m, --main [main-step-name]', 'The main step you want to run. Packflow will look up the main step defined in the packflow file if not specified.')
    .option('-w, --watch', 'Watch changes of files be packed.')
    .parse(process.argv)

  packflowProject = require path.resolve process.cwd(), 'packflow'
  exports.pack packflowProject,
    main : program.main
    watch : program.watch

exports.pack = (project, options) ->
  packer = new Packer project, options
  __doPack()

__now = ->
  now = new Date
  "#{now.getFullYear()}-#{now.getMonth()+1}-#{now.getDate()} #{now.getHours()}:#{now.getMinutes()}:#{now.getSeconds()}"

__doPack = ->
  isPacking = true
  fileChanged = false
  project = packer.getProject()
  options = packer.getOptions()
  packer.clean()
  mainStepName = options.main || project.main || 'main'
  packer.processStep mainStepName, null, (err, result) ->
    if err then console.log err.message
    console.log "[#{__now()}] packed: #{project.name}"
    isPacking = false

    if not fileWatched and options.watch
      __watchFiles packer.getFilesRead()
    
    if fileChanged
      __doPack()

__watchFiles = (fileNames) ->
  for fileName in fileNames
    fs.watchFile fileName, __hFileChanged
  fileWatched = true

__hFileChanged = ->
  if isPacking
    fileChanged = true
  else
    __doPack()

