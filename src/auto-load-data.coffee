Promise     = require 'bluebird'
isUndefined = require 'util-ex/lib/is/type/undefined'

autoupdate  = require './auto-update'
loadDataFrom= require './load-data-from'
modelNames    = require './model-names'

# import data
module.exports = (aApp, aOptions) ->
  aDataFolder = aOptions and aOptions.fixtures
  throw new TypeError 'Missing data folder' unless aDataFolder
  vModels = (aOptions and aOptions.models) || modelNames
  vModels = vModels.map (model)->aApp.models[model]
  vModels = Promise.map vModels, (model, index)->
    loadDataFrom(aApp, model, aDataFolder)

