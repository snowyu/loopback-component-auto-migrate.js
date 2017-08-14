require './register-config-file-format'

Promise     = require "bluebird"
inflection  = require 'inflection'
path        = require 'path'
isFunction  = require 'util-ex/lib/is/type/function'
isArray     = require 'util-ex/lib/is/type/array'
isString    = require 'util-ex/lib/is/type/string'
debug       = require('debug')('loopback:component:autoMigrate:loadDataFrom')

loadData    = require './load-data'
loadConfig  = require 'load-config-file'
loadConfig  = loadConfig.load

# load data to Model from a folder
module.exports = (app, Model, folder, raiseError, done) ->
  Model = app.models[Model] if isString Model
  return Promise.reject(new TypeError 'Missing Model').asCallback(done) unless Model

  vName = './' + inflection.transform Model.modelName, ['underscore', 'dasherize']
  loadConfig path.resolve folder, vName
  .then (data)->
    data = loadData Model, data, raiseError if data
    data
  .asCallback done
  # vData = loadConfig path.resolve folder, vName
  # console.log vData
  # if vData
  #   loadData Model, vData, done
  # else
  #   done()

