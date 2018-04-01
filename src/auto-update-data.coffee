Promise        = require 'bluebird'
autoupdate     = require './auto-update'
loadDataFrom   = require './load-data-from'

# update database and import data(if aDataFolder exists)
module.exports = (aApp, aOptions, vModelNames) ->
  aDataFolder = aOptions and aOptions.fixtures
  result = autoupdate(aApp, aOptions)
  raiseError = aOptions?.raiseError
  if aDataFolder
    result = result.then (models)->
      models = Promise.map vModelNames, (model, index)->
        loadDataFrom(aApp, model, aDataFolder, raiseError)
      models
  result

