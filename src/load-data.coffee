Promise     = require "bluebird"

isFunction  = require 'util-ex/lib/is/type/function'
isArray     = require 'util-ex/lib/is/type/array'
isString    = require 'util-ex/lib/is/type/string'
debug       = require('debug')('loopback:component:autoMigrate:loadData')
loopback    = require 'loopback'
path        = require 'path'

# import data to database from /server/data/ folder
# need promise to done.
module.exports = (Model, data, raiseError, done) ->
  reject = (err)->
    Promise.reject err
    .asCallback done

  vFile = if data.$cfgPath then path.basename(data.$cfgPath) else 'DATA'
  return reject(new TypeError '%s: The data should be an array.', vFile) unless isArray data
  Model = loopback.getModel(Model) if isString Model
  return reject(new TypeError '%s: Missing Model', vFile) unless Model

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
                .catch (err)->
                  throw err if raiseError
                  debug '(IGNORE) Relation %s(%s) %O', Model.modelName, k, err
            )(vRelation, v)
        result = Promise.all(delayed) if delayed.length
      result
    .catch (err)->
      throw err if raiseError
      debug '(IGNORE) %s %O', Model.modelName, err
  .each (result, index)->
    debug '%s: %O', Model.modelName, result
    return result
  .then (results)->
    debug Model.modelName + ': total ' + results.length + ' data created.'
    return results
  .catch (err)->
    err.name = vFile + ':' + err.name
    throw err
  .asCallback done
