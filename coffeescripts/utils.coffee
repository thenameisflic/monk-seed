module.exports = 
	allowCORS: (app) -> 
		app.all '*', (req, res,next) -> 
			res.header 'Access-Control-Allow-Credentials', true;
			res.header 'Access-Control-Allow-Origin', req.headers.origin;
			res.header 'Access-Control-Allow-Headers', if req.headers['access-control-request-headers'] then req.headers['access-control-request-headers'] else 'Content-Type,X-CSRF-Token, X-Requested-With, Accept, Accept-Version, Content-Length, Content-MD5,  Date, X-Api-Version, X-File-Name';
			res.header 'Access-Control-Allow-Methods', if (req.headers['access-control-request-method']) then req.headers['access-control-request-method'] else 'POST, GET, PUT, DELETE, OPTIONS';

			if 'OPTIONS' == req.method then res.sendStatus 200 else next();
	rejectBadRequest : (req, res, next, route) -> 
		rejected = false;
		for typeName, type of route.expects
			for expect in type
				if !req[typeName][expect]?
					res.sendStatus 400
					rejected = true;
					return;
		next() unless (rejected) 
	setupAuthData : (req, res, next, route) -> 
		models.Token.findOne({ _id : req.headers['x-auth-token']})
			.populate('user')
			.exec((err, token) ->
				if (err)
					res.sendStatus(500) 
				else 
					if (token)
						req.auth = {};
						req.auth.username = token.user.username;
						next();
					else if (route.auth == 'optional')
						res.sendStatus(401);
			)