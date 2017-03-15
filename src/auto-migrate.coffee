Promise       = require 'bluebird'
path          = require 'path'
isFunction    = require 'util-ex/lib/is/type/function'
isUndefined   = require 'util-ex/lib/is/type/undefined'
debug         = require('debug')('loopback:component:autoMigrate:autoMigrate')
appRoot       = require 'app-root-path'
models        = require appRoot + '/server/model-config.json'
modelNames    = require './model-names'

# drop all tables and create all tables from models.
module.exports = (app, options)->
  vModels = []
  vModelNames = (options and options.models) || modelNames
  Promise.map vModelNames, (model)->
    ds = app.dataSources[models[model].dataSource]
    ds.setMaxListeners(0)
    if ds.connected
      result = ds.automigrate model
    else
      new Promise (resolve, reject)->
        ds.once 'connected', ->
          resolve ds.automigrate model
  .each (item, index)->
    item = vModelNames[index] unless item
    debug 'Model ' + item + ' automigrated'
    vModels.push app.models[item]
  .then (results)->
    debug 'total '+results.length+ ' models migrated.'
    return vModels

