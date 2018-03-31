Promise        = require 'bluebird'
isString       = require 'util-ex/lib/is/type/string'
autoupdate     = require './auto-update'
loadDataFrom   = require './load-data-from'
modelNames     = require './model-names'
loadModelsFrom = require './load-models-from'

# update database and import data(if aDataFolder exists)
module.exports = (aApp, aOptions) ->
  aDataFolder = aOptions and aOptions.fixtures
  result = autoupdate(aApp, aOptions)
  raiseError = aOptions?.raiseError
  if aDataFolder
    result = result.then (models)->
      vModelNames = aOptions?.models || modelNames
      # if models are coming from a JSON file, load the file and insert into vModelNames array
      vModelNames = loadModelsFrom(aApp, vModelNames) if isString vModelNames
      models = Promise.map vModelNames, (model, index)->
        loadDataFrom(aApp, model, aDataFolder, raiseError)
      models
  result

