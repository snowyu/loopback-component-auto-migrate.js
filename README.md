# Loopback Component auto migrate database and load data

This loopback component enables you to migrate the database and import datas automatcally for the loopback application.


### Installation

1. Install in you loopback project:

  `npm install --save loopback-component-auto-migrate`

2. Create a component-config.json file in your server folder (if you don't already have one)

3. Configure options inside `component-config.json`:

  ```json
  {
    "loopback-component-auto-migrate": {
      "enabled": true,
      "migration": "auto-migrate-data",
      "models": ['Role'],
      "fixtures": './test/fixtures/'
    }
  }
  ```
  - `enabled` *[Boolean]*: whether enable this component. *defaults: true*
  - `migration` *[String]* : the migration ways:
    * "auto-migrate": drop and recreate the tables of the database.
    * "auto-migrate-data": drop and recreate the tables, load datas from `fixtures` folder.
    * "auto-update" *defaults*: update the tables of the databse.
    * "auto-update-data": update the tables, load datas from `fixtures` folder.
    * "auto-load-data": load datas from `fixtures` folder.
  - `models` *[String]*: the models to process. *defaults to the all models in the model-config.json*
  - `fixtures` *[String]*: the datas folder to import.


### Usage


Just enable it on `component-config.json`.

or run `node_modules/.bin/slc-migrate` directly.

set `DEBUG=loopback:component:autoMigrate:*` env vaiable to show debug info.

Manually use it:

```js

autoMigrate = require('loopback-component-auto-migrate/lib/auto-migrate');
autoMigrate(app, {fixtrues: dataFolder}).then()

```


