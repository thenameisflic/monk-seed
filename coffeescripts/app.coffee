routes  = require './routes.js'
bodyParser = require 'body-parser'
path = require 'path'
express = require 'express'
app = express()
models = require('mongoose').models
outline = require '../outline.js'
utils = require './utils.js'

# Default parsers
app.use express.static(path.resolve(outline.dist))
app.use bodyParser.urlencoded({ extended: false })
app.use bodyParser.json();

utils.allowCORS(app);

# Setup routes
for route in routes
	for name, config of route
		console.log "name : #{config.auth}"
		url = name.split('.')[0];
		if config.auth in ['true', 'optional']
			app[config.method](url, (req, res, next) -> utils.setupAuthData req, res, next, config)
		app[config.method](url, (req, res, next) -> utils.rejectBadRequest(req, res, next, config))
		app[config.method](url, config.fn);

app.get '*/', (req, res) -> res.sendFile path.resolve("#{__dirname}/../#{outline.dist}/#{req.path}")
app.get '/', (req, res) -> res.sendFile path.resolve("#{__dirname}/../#{outline.dist}/index.html")

module.exports = app;