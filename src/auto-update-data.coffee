Promise       = require 'bluebird'
autoupdate    = require './auto-update'
loadDataFrom  = require './load-data-from'
modelNames    = require './model-names'

# update database and import data(if aDataFolder exists)
module.exports = (aApp, aOptions) ->
  aDataFolder = aOptions and aOptions.fixtures
  result = autoupdate(aApp)
  if aDataFolder
    result = result.then (models)->
      vModelNames = (aOptions and aOptions.models) || modelNames
      models = Promise.map vModelNames, (model, index)->
        loadDataFrom(aApp, model, aDataFolder)
      models
  result

