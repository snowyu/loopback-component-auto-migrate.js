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
    Model.create item
    .then (result)->
      if result
        delayed = []
        for k,v of item
          # try to determine the hasMany relation
          vRelation = result[k]
          if isFunction(vRelation) and isFunction(vRelation.create) and isArray(v)
            ((aRelation, aData)->
              delayed.push Promise.map aData, (data)->
                aRelation.create data
            )(vRelation, v)
        result = Promise.all(delayed) if delayed.length
      result
  .each (result, index)->
    debug '%s: %o', Model.modelName, result
    return result
  .then (results)->
    debug Model.modelName + ': total ' + results.length + ' data created.'
    return results
  .catch (err)->
    debug err.message
    throw err
  .asCallback done
