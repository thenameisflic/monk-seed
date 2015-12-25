# monk-seed
Monk Framework seed implementation.
### Getting started
1) Clone this repo.
2) Edit ```outline.json``` with your project characteristics, like name and folder structure.
3) In the project root folder, execute ```gulp```.
4) Happy coding!
### Gulp tasks
- gulp sass: Compiles all SASS in your ```src``` folder into a single ```dist/css/<project_name>.min.css```.
- gulp coffee: Compiles all CoffeeScript in your ```src``` folder into a single ```dist/js/<project_name>.min.js```.
- gulp index: Generates index.html files, automatically injecting your dependencies from ```bower.json```.
- gulp build [-p]: Builds your project. If used with -p, minifies CSS and uglifies JS.
- gulp (default task): Starts a live reload server, which will watch for changes on project files, rebuild your project and reload all connected browsers.
