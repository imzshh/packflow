Packer = require './packer'
fs = require 'fs'

isPacking = false
fileChanged = false
fileWatched = false
packer = null

exports.pack = (project) ->
  packer = new Packer project
  __doPack()

__now = ->
  now = new Date
  "#{now.getFullYear()}-#{now.getMonth()+1}-#{now.getDate()} #{now.getHours()}:#{now.getMinutes()}:#{now.getSeconds()}"

__doPack = ->
  isPacking = true
  fileChanged = false
  project = packer.getProject()
  packer.clean()
  packer.processStep project.main || 'main', null, (err, result) ->
    if err then console.log err.message
    console.log "[#{__now()}] packed: #{project.name}"
    isPacking = false

    if not fileWatched
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

