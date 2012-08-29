Async = require 'async'
StepProcessor = require '../step-processor'

class CombineStepProcessor extends StepProcessor
  process : (input, callback) ->
    allResults = []
    packer = @_packer
    Async.forEachSeries @_step.steps, (subStepName, callback) ->
      packer.processStep subStepName, null, (err, output) ->
        if err then return callback err

        if output and output.length
          allResults.push.apply allResults, output
        callback()
    , (err) ->
      if err then return callback err
      callback null, allResults

module.exports = CombineStepProcessor

