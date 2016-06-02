Promise     = require "bluebird"

isFunction  = require 'util-ex/lib/is/type/function'
isArray     = require 'util-ex/lib/is/type/array'
isString    = require 'util-ex/lib/is/type/string'
debug       = require('debug')('loopback:component:autoMigrate:loadData')
loopback    = require 'loopback'

# import data to database from /server/data/ folder
# need promise to done.
module.exports = (Model, data, done) ->
  reject = (err)->
    Promise.reject err
    .asCallback done

  return reject(new TypeError 'The data should be an array.') unless isArray data
  Model = loopback.getModel(Model) if isString Model
  return reject(new TypeError 'Missing Model') unless Model

  Promise.map data, (item)->
    Model.upsert item
  .each (item, index)->
    debug '%s: %o', Model.modelName, item
    return item
  .then (results)->
    debug Model.modelName + ': total ' + results.length + ' data created.'
    return results
  .catch (err)->
    debug err.message
    throw err
  .asCallback done
