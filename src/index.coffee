'use strict'
require './register-config-file-format'

debug       = require('debug')('loopback:component:autoMigrate:main')
path        = require 'path'
isString    = require 'util-ex/lib/is/type/string'
loadCfgSync = (require 'load-config-file').loadSync

module.exports = (app, options) ->
  debug 'initializing component'
  if app.get('loopback-component-auto-migrate-status')
    debug 'already migrating'
    return
  loopback = app.loopback
  loopbackMajor = loopback and loopback.version and loopback.version.split('.')[0] or 1
  if loopbackMajor < 2
    throw new Error('loopback-component-auto-migrate requires loopback 2.0 or newer')

  if !options or options.enabled isnt false
    migration = (options and options.migration) or 'auto-update'
    autoMigrate = require './' + migration
    raiseError = (options and options.migration)
    app.set('loopback-component-auto-migrate-status', 'loaded')
    vModels = (options and options.models)
    # a config file location instead of passing all list inside 'component-config.json'
    options.models = loadCfgSync(path.resolve(vModels)) if isString vModels

    autoMigrateDone = autoMigrate(app, options)
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
