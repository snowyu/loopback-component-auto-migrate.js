'use strict'
debug = require('debug')('loopback:component:autoMigrate:main')

isString       = require 'util-ex/lib/is/type/string'
modelNames     = require './model-names'
loadModelsFrom = require './load-models-from'

module.exports = (app, options) ->
  debug 'initializing component'
  loopback = app.loopback
  loopbackMajor = loopback and loopback.version and loopback.version.split('.')[0] or 1
  if loopbackMajor < 2
    throw new Error('loopback-component-auto-migrate requires loopback 2.0 or newer')

  if !options or options.enabled isnt false
    migration = (options and options.migration) or 'auto-update'
    autoMigrate = require './' + migration
    raiseError = (options and options.migration)
    app.set('loopback-component-auto-migrate-status', 'loaded')

    vModels = (options and options.models) || modelNames
    # if models are coming from a config file, load the file and insert into vModels array
    vModels = loadModelsFrom(app, vModels) if isString vModels

    autoMigrateDone = autoMigrate(app, options, vModels)
      .asCallback (err)->
        if err
          app.set('loopback-component-auto-migrate-error', err)
          app.set('loopback-component-auto-migrate-status', 'failed')
          debug migration + ' failed: %O', err
          throw err if raiseError
        else
          app.set('loopback-component-auto-migrate-status', 'done')

    app.set('loopback-component-auto-migrate-done', autoMigrateDone) # set the `done` promise of the `autoMigrate()` call

    return autoMigrateDone
  else
    debug 'component not enabled'
