Promise     = require 'bluebird'

automigrate = require './auto-migrate'
loadDataFrom= require './load-data-from'

# Migrate database and import data(if aDataFolder exists)
module.exports = (aApp, aOptions) ->
  result = automigrate(aApp, aOptions)
  aDataFolder = aOptions and aOptions.fixtures
  raiseError = aOptions?.raiseError
  if aDataFolder
    result = result.then (models)->
      if aDataFolder
        models = Promise.map models, (model, index)->
          loadDataFrom(aApp, model, aDataFolder, raiseError)
      models
  result
