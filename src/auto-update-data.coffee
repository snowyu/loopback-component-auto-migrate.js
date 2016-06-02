Promise     = require('bluebird')

autoupdate = require('./auto-update')
loadDataFrom= require('./load-data-from')

# update database and import data(if aDataFolder exists)
module.exports = (aApp, aOptions) ->
  aDataFolder = aOptions and aOptions.fixtures
  result = autoupdate(aApp)
  if aDataFolder
    result = result.then (models)->
      models = Promise.map models, (model, index)->
        loadDataFrom(aApp, model, aDataFolder)
      models
  result

