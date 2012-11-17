Packer = require './packer'
fs = require 'fs'
path = require 'path'

isPacking = false
fileChanged = false
fileWatched = false
packer = null

exports.run = ->
  program = require 'commander'
  program.version('0.3.1')
    .option('-w, --watch', 'Watch changes of files be packed.')
    .parse(process.argv)

  fileName = path.resolve 'packflow'
  console.log fileName
  if fs.existsSync fileName + '.coffee'
    script = """
fs = require 'fs'
packflowProject = require fs.realpathSync 'packflow.coffee'
packflow = require 'packflow'
packflow.pack packflowProject
"""
    options = ''
    if program.watch
      options += 'watch : true'

    if options
      script += ", {#{options}}"

    CoffeeScript = require 'coffee-script'
    CoffeeScript.run  script, filename : 'packflow.coffee'

  else if fs.existsSync fileName + '.js'
    packflowProject = require fs.realpathSync 'packflow.js'
    exports.pack packflowProject,
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

