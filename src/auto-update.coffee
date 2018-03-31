Promise        = require "bluebird"
path           = require 'path'
isFunction     = require 'util-ex/lib/is/type/function'
isUndefined    = require 'util-ex/lib/is/type/undefined'
isString       = require 'util-ex/lib/is/type/string'
debug          = require('debug')('loopback:component:autoMigrate:autoUpdate')
appRoot        = require 'app-root-path'
models         = require appRoot + '/server/model-config.json'
modelNames     = require './model-names'
loadModelsFrom = require './load-models-from'


isSyncModel = (ds, model)->
  new Promise (resolve, reject)->
    ds.setMaxListeners(0)
    if ds.connected
      ds.isActual model, (err, actual)->
        #True when data source and database is in sync
        if err then reject(err) else resolve(actual)
    else
      ds.once 'connected', ->
        ds.isActual model, (err, actual)->
          #True when data source and database is in sync
          if err then reject(err) else resolve(actual)

# drop all tables and create all tables from models.
module.exports = (app, options)->
  vModels = []
  vModelNames = (options and options.models) || modelNames
  # if models are coming from a JSON file, load the file and insert into vModelNames array
  vModelNames = loadModelsFrom(app, vModelNames) if isString vModelNames
  Promise.filter vModelNames, (model, index)->
    ds = app.dataSources[models[model].dataSource]
    isSyncModel(ds, model).then (actual)-> !actual
  .map (model, index)->
    ds = app.dataSources[models[model].dataSource]
    ds.autoupdate(model)
  .each (item, index)->
    item = vModelNames[index] unless item
    debug 'Model ' + item + ' autoupdated'
    vModels.push app.models[item]
  .then (results)->
    debug 'total '+results.length+ ' models updated.'
    return vModels

