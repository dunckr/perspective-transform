var gulp = require('gulp');

// Run this to compress all the things!
gulp.task('build', ['production'], function() {
  gulp.start(['zip']);
});
