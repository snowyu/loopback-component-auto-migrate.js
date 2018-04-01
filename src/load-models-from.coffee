require './register-config-file-format'

path        = require 'path'
debug       = require('debug')('loopback:component:autoMigrate:loadModelsFrom')

loadConfig  = require 'load-config-file'
loadConfig  = loadConfig.loadSync

# load Models synchronously from a file
module.exports = (app, folder) ->
  return loadConfig path.resolve(folder), 'utf8'
