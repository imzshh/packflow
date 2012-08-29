Fs = require 'fs'
Path = require 'path'

exports.ensureDirExistsSync = (dirPath) ->
  dirsToMake = []

  while not Fs.existsSync dirPath
      lastIndexOfSep = dirPath.lastIndexOf '/'

      if lastIndexOfSep is -1
        break

      dirName = dirPath.substr lastIndexOfSep + 1
      dirsToMake.push dirName
      dirPath = dirPath.substr 0, lastIndexOfSep

  while dirsToMake.length
    dirName = dirsToMake.shift()

    dirPath = Path.join dirPath, dirName
    Fs.mkdirSync dirPath

exports.ensureDirOfFileExistsSync = (filePath) ->
  exports.ensureDirExistsSync Path.dirname filePath
