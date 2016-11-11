'use strict'
debug = require('debug')('loopback:component:autoMigrate')

module.exports = (app, options) ->
  debug 'initializing component'
  loopback = app.loopback
  loopbackMajor = loopback and loopback.version and loopback.version.split('.')[0] or 1
  if loopbackMajor < 2
    throw new Error('loopback-component-auto-migrate requires loopback 2.0 or newer')

  if !options or options.enabled isnt false
    autoMigrate = (options and options.migration) or 'auto-update'
    autoMigrate = require './' + autoMigrate
    autoMigrate(app, options)
  else
    Promise.resolve().then (res) ->
      TypeError 'component not enabled'
