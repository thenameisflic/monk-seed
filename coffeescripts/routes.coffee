fs        = require('fs');
path      = require('path');
env       = process.env.NODE_ENV || 'dev';

routes = [];

fs
  .readdirSync __dirname + '/endpoints'
  .filter (file) -> (file.indexOf('.') != 0) && (file != 'index.js');
  .forEach (file) -> routes.push(require "#{__dirname}/endpoints/#{file}");

module.exports = routes;