config    = require "#{__dirname}/../../outline.js",
mongoose  = require 'mongoose';

mongoose.connect "mongodb://#{config.db.host}/#{config.db.name}", user: config.db.username, pass: config.db.password;

db = mongoose.connection;
db.on 'error', console.error.bind(console, 'connection error:');
db.once 'open', -> require('./models')(mongoose);

module.exports = db;