Async = require 'async'
StepProcessor = require '../step-processor'

class WaterfallStepProcessor extends StepProcessor
  process : (input, callback) ->
    lastResults = input
    packer = @_packer
    Async.forEachSeries @_step.steps, (subStepName, callback) ->
      packer.processStep subStepName, lastResults, (err, output) ->
        if err then return callback err

        lastResults = output
        callback()
    , (err) ->
      if err then return callback err
      callback null, lastResults

module.exports = WaterfallStepProcessor

