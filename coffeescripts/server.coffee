serverConfig	 = require('../outline.js').server
app      = require './app.js'
db 		 = require './mongo'

db.once 'open', -> 
	app.listen serverConfig.port, serverConfig.ip, ->
		console.log "Express server listening on port #{serverConfig.port}"