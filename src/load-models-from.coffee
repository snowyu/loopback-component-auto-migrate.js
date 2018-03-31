require './register-config-file-format'

fs          = require 'fs'
inflection  = require 'inflection'
path        = require 'path'
debug       = require('debug')('loopback:component:autoMigrate:loadModelsFrom')

loadConfig  = require 'load-config-file'
loadConfig  = loadConfig.load

# load Models synchronously from a file
module.exports = (app, folder) ->
  return JSON.parse fs.readFileSync path.resolve(folder), 'utf8'
