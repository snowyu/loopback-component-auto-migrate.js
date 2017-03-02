'use strict'
debug = require('debug')('loopback:component:autoMigrate:main')

module.exports = (app, options) ->
  debug 'initializing component'
  loopback = app.loopback
  loopbackMajor = loopback and loopback.version and loopback.version.split('.')[0] or 1
  if loopbackMajor < 2
    throw new Error('loopback-component-auto-migrate requires loopback 2.0 or newer')

  if !options or options.enabled isnt false
    autoMigrate = (options and options.migration) or 'auto-update'
    autoMigrate = require './' + autoMigrate
    app.autoMigrateDone = autoMigrate(app, options).then -> debug "Done"
  else
    debug 'component not enabled'
