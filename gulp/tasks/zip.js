var gulp = require('gulp');
var zip = require('gulp-zip');

gulp.task('zip', ['setupDirectory'], function() {
  return gulp.src('build/*')
    .pipe(zip('archive.zip'))
    .pipe(gulp.dest('dist'));
});

gulp.task('setupDirectory', function() {
  // need to mv sketch and lib into this
  // also www into subfolder...
  // mirror current structure
});
