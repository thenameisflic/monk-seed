var PORT =  process.env.OPENSHIFT_NODEJS_PORT || 8080;
var IP_ADDRESS = process.env.OPENSHIFT_NODEJS_IP || "";
var DB_HOST = process.env.OPENSHIFT_MONGODB_DB_HOST || "localhost";
var DB_PORT = process.env.OPENSHIFT_MONGODB_DB_HOST || 3306;
var DB_NAME = "wigo";
var DB_USERNAME = process.env.OPENSHIFT_MONGODB_DB_HOST ? "admin" : "" ;
var DB_PASSWORD = process.env.OPENSHIFT_MONGODB_DB_HOST ? "bfTNX_RtgMuG" : "" ;

module.exports = {
	"name": "monk-seed",
	"src": "src",
	"dist": "www",
	"coffeeScripts": "coffeescripts",
	"scripts": "scripts",
	"constants": {
	    "production": {},
	    "development": {}
	},
	"db" : {
		"name": DB_NAME,
		"username": DB_USERNAME,
		"password": DB_PASSWORD,
		"host": DB_HOST,
		"port": DB_PORT,
		"logging": true
	},
	"server" : {
		"port": PORT,
		"ip": IP_ADDRESS
	}
};