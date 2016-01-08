outline = require './outline.js'

gulp = require 'gulp'
jade = require 'gulp-jade'
coffee = require 'gulp-coffee'
sass = require 'gulp-sass'
templateCache = require 'gulp-angular-templatecache';
plumber = require 'gulp-plumber'
browserSync = require 'browser-sync'
reload = browserSync.reload
bowerFiles = require 'main-bower-files'
inject = require 'gulp-inject'
ngAnnotate = require 'gulp-ng-annotate'
concat = require 'gulp-concat'
uglify = require 'gulp-uglify'
watch = require 'gulp-watch'
ngConstant = require 'gulp-ng-constant'
gulpif = require 'gulp-if'
htmlreplace = require 'gulp-html-replace'
minifyCss = require 'gulp-minify-css'
args = require 'yargs'
	.alias 'p', 'prod'
	.default 'prod', false
	.argv;

paths = 
	coffee: "#{outline.src}/**/*.coffee"
	sass: "#{outline.src}/**/*.scss"
	jade: "#{outline.src}/**/*.jade"
	assets: "#{outline.src}/assets/**/*"
	server: "#{outline.coffeeScripts}/**/*.coffee"

indexInject = 
	'templateCache': 'js/templates.js'
	'jsBundle': "js/#{outline.name}.min.js"
	'cssBundle': "css/#{outline.name}.min.css"

gulp.task 'browser-sync', ->
	browserSync server: baseDir: outline.dist

gulp.task 'config', ->
	constants = if args.prod then outline.constants.production else outline.constants.development
	gulp.src 'package.json'
		.pipe concat('outline.json')
		.pipe ngConstant({name: "outline", constants: constants})
		.pipe gulp.dest("#{outline.dist}/js/")

gulp.task 'index', ->
	gulp.src "#{outline.src}/index.jade"
		.pipe plumber()
		.pipe jade(pretty: true)
		.pipe htmlreplace(indexInject)
		.pipe inject(gulp.src(bowerFiles(), read: false), {name: 'bower', addRootSlash: false, ignorePath: "/#{outline.dist}"})
		.pipe gulp.dest("#{outline.dist}")

gulp.task 'jade', ['index'], ->
	gulp.src [paths.jade, '!**/*/index.jade']
		.pipe plumber()
		.pipe jade(pretty: true)
		.pipe templateCache({standalone: true})
		.pipe gulp.dest("#{outline.dist}/js")
		.pipe reload(stream: true)

gulp.task 'sass', ->
	gulp.src [paths.sass]
		.pipe plumber()
		.pipe sass(outputStyle: 'compressed').on('error', sass.logError)
		.pipe concat("#{outline.name}.min.css")
		.pipe gulpif(args.prod, minifyCss())
		.pipe gulp.dest("#{outline.dist}/css")
		.pipe reload(stream: true)

gulp.task 'coffee', ['config'], ->
	gulp.src ["#{outline.dist}/js/outline.js", paths.coffee]
		.pipe plumber()
		.pipe gulpif(/[.]coffee$/, coffee())
		.pipe concat("#{outline.name}.min.js")
		.pipe ngAnnotate()
		.pipe gulpif(args.prod, uglify())
		.pipe gulp.dest("#{outline.dist}/js")
		.pipe reload(stream: true)

gulp.task 'assets', ->
	gulp.src paths.assets
		.pipe gulp.dest("#{outline.dist}/assets")

gulp.task 'deploy', ->
	gulp.src paths.server
		.pipe plumber()
		.pipe coffee()
		.pipe gulp.dest("#{outline.scripts}")

gulp.task 'watch', ->
	watch paths.sass, -> gulp.start 'sass'
	watch paths.jade, -> gulp.start 'jade'
	watch paths.coffee, -> gulp.start 'coffee'
	watch paths.assets, -> gulp.start 'assets'
	watch paths.server, -> gulp.start 'deploy'

gulp.task 'build', ['assets', 'jade', 'coffee', 'sass']
gulp.task 'default', ['build', 'deploy', 'browser-sync', 'watch']