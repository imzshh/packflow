Async = require 'async'
StepProcessor = require '../step-processor'

class SequenceStepProcessor extends StepProcessor
  process : (input, callback) ->
    packer = @_packer
    Async.forEachSeries @_step.steps, (subStepName, callback) ->
      packer.processStep subStepName, null, (err, output) ->
        if err then return callback err

        callback()
    , (err) ->
      if err then return callback err
      callback()

module.exports = SequenceStepProcessor

