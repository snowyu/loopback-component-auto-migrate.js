# Get all available Model names

isUndefined = require 'util-ex/lib/is/type/undefined'
appRoot     = require 'app-root-path'
models      = require appRoot + '/server/model-config.json'
datasources = require appRoot + '/server/datasources.json'

module.exports = Object.keys(models).filter (model)->
    !(isUndefined(models[model].dataSource) or isUndefined(datasources[models[model].dataSource]))
