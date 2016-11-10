#!/bin/env node
var path        = require('path');
var Promise     = require('bluebird');
var appRoot     = require('app-root-path');

var app = require(appRoot + '/server/server');
var autoMigrateData = require('../lib/auto-migrate-data');
var autoUpdateData  = require('../lib/auto-update-data');
var autoLoadData    = require('../lib/auto-load-data');
var createDefaults;
try {
  createDefaults  = require(appRoot + '/server/common/create-defaults');
} catch(err) {
  createDefaults  = Promise.resolve();
}
var defaultFolder   = path.resolve(appRoot, './server/data');

function migrate(aDataFolder, forceCreate) {
  if (forceCreate === undefined) forceCreate = true;
  var options = {fixtures:aDataFolder};
  var result;
  if (forceCreate) {
    result = autoMigrateData(app, options)
    if (aDataFolder) result = result.then(function(){return createDefaults()})
    result.then(function(){
      console.log('autoMigrate successful.')
    })
    .error(function(err){
      console.log('autoMigrate failed:', err.message)
    })
  } else {
    result = autoUpdateData(app, options)
    if (aDataFolder) result = result.then(function(){return createDefaults()})
    result.then(function(){
      console.log('autoUpdate successful.')
    })
    .error(function(err){
      console.log('autoUpdate failed:', err.message)
    })
  }
}

module.exports = migrate;

function main() {
  var parseArgs = require('minimist');
  var info;
  var opts = {
    boolean: ['update', 'data', 'import'],
    alias: {'update':'u', 'data':'d', 'import':'i'},
    default:{'update': false, 'data': true}
  };
  var argv = parseArgs(process.argv.slice(2), opts);
  var folder = argv._.pop();
  var result;
  app.set('migrating', true)
  if (argv.import) {
    if (!folder) folder = defaultFolder;
    console.log('import data only:', folder);
    result = autoLoadData(app, {fixtures:folder})
    if (folder) result = result.then(function(){return createDefaults()})
    result.then(function(){
      console.log('import successful.')
    })
    .error(function(err){
      console.log('import failed:', err.message)
    })
  } else {
    if (argv.data && !folder) folder = defaultFolder;
    info = 'Migrate database';
    if (folder) info += ': ' + folder;
    console.log(info)
    migrate(folder, !argv.update);
  }
  // argv
  // .version('v0.1.0')
  // .info('Migrate the database and data.')
  // .option({
  //   name: 'update',
  //   short: 'u',
  //   type: 'boolean',
  //   description: 'update database only, defaults to false'
  // })
  // .option({
  //   name: 'load',
  //   short: 'l',
  //   type: 'boolean',
  //   description: 'load data'
  // })
  // ;
  // var args = argv.run();
  // var folder = argv.targets.pop()
  // console.log(args);
  // if (args.options.load) {

  // } else {
  //   if (args.options.update !== undefined) args.options.update = !args.options.update;
  //   migrate(folder, args.options.update);
  // }
}

if (require.main) {
  app.on('booted', main);
}
