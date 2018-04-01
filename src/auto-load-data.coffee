Promise        = require 'bluebird'
isUndefined    = require 'util-ex/lib/is/type/undefined'

autoupdate     = require './auto-update'
loadDataFrom   = require './load-data-from'

# import data
module.exports = (aApp, aOptions, vModels) ->
  aDataFolder = aOptions and aOptions.fixtures
  return Promise.reject new TypeError 'Missing data folder' unless aDataFolder
  vModels = vModels.map (model)->aApp.models[model]
  raiseError = aOptions?.raiseError
  vModels = Promise.map vModels, (model, index)->
    loadDataFrom(aApp, model, aDataFolder, raiseError)

