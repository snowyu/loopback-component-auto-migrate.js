# Get all available Model names

isUndefined = require 'util-ex/lib/is/type/undefined'
models      = require '../../../server/model-config.json'
datasources = require '../../../server/datasources.json'

module.exports = Object.keys(models).filter (model)->
    !(isUndefined(models[model].dataSource) or isUndefined(datasources[models[model].dataSource]))
