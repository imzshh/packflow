Packer = require './packer'

exports.pack = (project) ->
  pk = new Packer project
  pk.processStep project.main || 'main', null, (err, result) ->
    if err then console.log err.message
    console.log 'packed: ' + project.name
