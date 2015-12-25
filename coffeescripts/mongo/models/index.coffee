fs   = require 'fs'
path = require 'path'

module.exports = (mongoose) ->
  models = {}
  fs
    .readdirSync __dirname
      .filter (file) -> (file.indexOf('.') != 0) && (file != 'index.js')
      .forEach (file) ->
        schemaName = file.split('.')[0]
        schemaDefinition = require path.join(__dirname, file)
        schema = mongoose.Schema(schemaDefinition);
        models[schemaName] = mongoose.model schemaName, schema;
      return models;