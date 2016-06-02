loadConfig = require('load-config-file')
yaml  = require('js-yaml')
cson  = require('cson')

# register the load-config file formats.
loadConfig.register(['.yaml', '.yml'], yaml.safeLoad)
loadConfig.register('.cson', cson.parseCSONString.bind(cson))
loadConfig.register('.json', JSON.parse)
