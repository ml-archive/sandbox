'use strict';

import * as config from './gulp/config';
import gulp from 'gulp';
import vapor from 'gulp-vapor';


gulp.task('vapor:start', vapor.start);
gulp.task('vapor:reload', vapor.reload);

gulp.task('watch', () => {
	gulp.watch(config.vapor.path, ['vapor:reload']);
});

gulp.task('default', ['vapor:start', 'watch']);