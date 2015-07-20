# Gulp stuff.
gulp = require('gulp')
gutil = require('gulp-util')
coffee = require('gulp-coffee')
sourcemaps = require('gulp-sourcemaps')
touch = require('touch')
path = require('path')
tap = require('gulp-tap')

bower = require('bower')
concat = require('gulp-concat')
sass = require('gulp-sass')
minifyCss = require('gulp-minify-css')
rename = require('gulp-rename')
sh = require('shelljs')

parallelize = require("concurrent-transform")

threads = 100
useSourceMaps = true
coffeeFiles = ['./gulpfile.coffe','./www/js/**/*.coffee']

paths = {
    sass: ['./scss/**/*.scss']
}
handleError = (err) ->
    console.log(err.toString())
    @emit('end')

gulp.task('sass', (done) ->
    gulp.src('./scss/ionic.app.scss')
    .pipe(sass())
    .pipe(gulp.dest('./www/css/'))
    .pipe(minifyCss({
            keepSpecialComments: 0
        }))
    .pipe(rename({ extname: '.min.css' }))
    .pipe(gulp.dest('./www/css/'))
    .on('end', done)
)

gulp.task('install', ['git-check'], () ->
    return bower.commands.install()
    .on('log', (data) ->
        gutil.log('bower', gutil.colors.cyan(data.id), data.message)
    )
)

gulp.task('git-check', (done) ->
    if (!sh.which('git'))
        console.log(
            '  ' + gutil.colors.red('Git is not installed.'),
            '\n  Git, the version control system, is required to download Ionic.',
            '\n  Download git here:', gutil.colors.cyan('http://git-scm.com/downloads') + '.',
            '\n  Once git is installed, run \'' + gutil.colors.cyan('gulp install') + '\' again.'
        )
        process.exit(1)

    done()
)

gulp.task('touch', () ->
    gulp.src(coffeeFiles)
    .pipe(
        tap((file, t) ->
            touch(file.path)
        )

    )
)

gulp.task('coffeescripts', () ->
    gulp.src(coffeeFiles)
    .pipe(parallelize(coffee({bare: true}).on('error', gutil.log), threads))
    .pipe(parallelize((if useSourceMaps then sourcemaps.init() else gutil.noop()), threads))
)

gulp.task('watch', () ->
    gulp.watch(coffeeFiles, ['coffeescripts'])
    gulp.watch(paths.sass, ['sass'])
)

gulp.task('default', ['watch', 'coffeescripts', 'sass'])

gulp.task('done', (() -> ))
