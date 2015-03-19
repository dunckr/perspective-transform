var gulp = require('gulp');
var zip = require('gulp-zip');
var clean = require('gulp-clean');

var zipName = 'sketch-perspective';

gulp.task('zip', ['copy'], function() {
  return gulp.src('dist/**')
    .pipe(zip(zipName + '.zip'))
    .pipe(gulp.dest('dist'));
});

gulp.task('copy', ['clean'], function() {
  return gulp.src(['build/**', 'lib/**', '*.sketchplugin'], {
      base: './'
    })
    .pipe(gulp.dest('dist'));
});

gulp.task('clean', function() {
  return gulp.src('dist', {
      read: false
    })
    .pipe(clean());
});
