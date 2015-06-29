// Lets go
var gulp = require('gulp'),
    gutil = require('gulp-util'),
    c = require('chalk'),
    // del = require('del'),
    imagemin = require('gulp-imagemin'),
    concat = require('gulp-concat'),
    uglify = require('gulp-uglify'),
    jshint = require('gulp-jshint'),
    notify = require('gulp-notify'),
    autoprefixer = require('gulp-autoprefixer'),
    sass = require('gulp-sass'),
    scsslint = require('gulp-scss-lint'),
    minifycss = require('gulp-minify-css'),
    rename = require('gulp-rename'),
    include = require('gulp-include'),
    stylish = require('jshint-stylish'),
    sourcemaps = require('gulp-sourcemaps'),
    browserSync = require('browser-sync').create()


// Directories
var SRC = 'public_html/src',
    DIST = 'public_html/assets',
    TEMPLATES = 'templates';


// lint all styles, except vendor... we have no control over that
gulp.task('scss-lint', function() {

  gulp.src([SRC + '/styles/**/*.scss', '!' + SRC + '/styles/vendor/**/*'])
    .pipe(scsslint({
      'config': '.scss-lint.yml',
      'endless': true
    }))
    .pipe( scsslint.failReporter('E') );
});


gulp.task('styles', ['scss-lint'], function(){
  gulp.src(SRC + '/styles/main.scss')
    .pipe(sourcemaps.init())
    .pipe(
      sass({
        outputStyle: 'expanded',
        debugInfo: true,
        lineNumbers: true,
        errLogToConsole: true,
        onSuccess: function(){
          notify().write({ message: "SCSS Compiled!" });
        },
        onError: function(err) {
          gutil.beep();
          notify().write(err);
        }
      })
    )
   // .pipe(autoprefixer('last 2 version', 'safari 5', 'ie 9', 'opera 12.1', 'ios 6', 'android 4'))
    // .pipe(rename({ suffix: '.min' }))
    .pipe(sourcemaps.write())
    .pipe( gulp.dest(DIST + '/styles'))
    .pipe(browserSync.stream());
});

gulp.task("build-styles", function(){
  gulp.src( DIST + '/styles/main.min.css')
    .pipe(minifycss())
    .pipe(gulp.dest(DIST + '/styles'));
});


// JS files we'll be using
// NOT the vendor directory.. include in main using include
var JS = [
  '!' + SRC + '/js/vendor/**/*.js',
  SRC + '/js/**/*!(main)*.js',
  SRC + '/js/main.js'
];

// JS Lint
gulp.task("js-lint", function() {
  gulp.src( JS )
  .pipe(jshint())
  .pipe(jshint.reporter(stylish));
});

// JS Scripts
gulp.task("scripts", function() {
  gulp.src( JS )
    .pipe(concat('main.js'))
    .pipe(include())
    .pipe(gulp.dest(DIST + '/js'))
    .pipe(notify('JS Compiled!'));
});

gulp.task("build-scripts", function(){
	gulp.src(DIST + '/js/main.js')
    .pipe(rename('main.min.js'))
    .pipe(uglify())
    .pipe(gulp.dest(DIST + '/js'))
    .pipe(notify('JS Build Compiled!'));
});


// Image Minification
gulp.task('image-min', function () {
    return gulp.src( SRC + '/images/**/*')
        .pipe(imagemin())
        .pipe(gulp.dest( DIST + '/images' ))
        .pipe(notify('Images Compressed!'));
});

// Fonts
gulp.task('fonts', function() {
  gulp.src(SRC + '/fonts/**/*')
  .pipe(gulp.dest(DIST + '/fonts'));
});

// Clean dist directory for rebuild
// gulp.task('clean', function() {
//   del([
//     DIST + '/**/*'
//   ])
// });

// Watch
gulp.task('watch', function() {

  browserSync.init({
    proxy: "crafttest.dev"
  });

  // Watch .scss files
  gulp.watch( SRC + '/styles/**/*.scss', ['styles']);
  // Watch .js files to lint and build
  gulp.watch( SRC + '/js/*.js', ['js-lint', 'scripts']);
  // Watch image files
  gulp.watch( SRC + '/images/**/*', ['image-min']);

  // watch images, js & html
  gulp.watch( [DIST + '/images/**/*', DIST + '/js/*.js', TEMPLATES + '/**/*.html']).on('change', browserSync.reload);


});

// Gulp Build (compresses stuff as that's time conusming for dev)
gulp.task('build', ['build-scripts', 'build-styles']);

// Gulp Default Task
gulp.task('default', ['styles', 'js-lint', 'scripts', 'fonts', 'image-min', 'watch']);