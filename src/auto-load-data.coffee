Promise        = require 'bluebird'
isUndefined    = require 'util-ex/lib/is/type/undefined'
isString       = require 'util-ex/lib/is/type/string'

autoupdate     = require './auto-update'
loadDataFrom   = require './load-data-from'
modelNames     = require './model-names'
loadModelsFrom = require './load-models-from'

# import data
module.exports = (aApp, aOptions) ->
  aDataFolder = aOptions and aOptions.fixtures
  return Promise.reject new TypeError 'Missing data folder' unless aDataFolder
  vModels = (aOptions and aOptions.models) || modelNames
  # if models are coming from a JSON file, load the file and insert into vModels array
  vModels = loadModelsFrom(aApp, vModels) if isString vModels
  vModels = vModels.map (model)->aApp.models[model]
  raiseError = aOptions?.raiseError
  vModels = Promise.map vModels, (model, index)->
    loadDataFrom(aApp, model, aDataFolder, raiseError)

