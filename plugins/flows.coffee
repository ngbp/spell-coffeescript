coffee = require 'gulp-coffee'
coffeelint = require 'gulp-coffeelint'
sourcemaps = require('gulp-sourcemaps');

module.exports = ( warlock ) ->
  warlock.flow 'coffee-to-build',
    source: [ '<%= globs.source.coffeescript %>' ]
    source_options:
      base: "<%= paths.source_app %>"
    tasks: [ 'webapp-build' ]
    merge: 'flow::scripts-to-build::90'

  .add( 10, 'coffeescript-lint.lint', coffeelint )
  .add( 11, 'coffeescript-lint.report', coffeelint.reporter )
  .add( 12, 'coffeescript-lint.failOnError', ( options ) ->
    warlock.streams.map ( file ) ->
      return file if not options.fail or not file.coffeelint or file.coffeelint.success
      warlock.fatal "One or more CoffeeScript files failed linting. I'm going to exit now."
  )
  .add( 50, 'coffeescript-sourcemaps-init', sourcemaps.init )
  .add( 51, 'coffeescript-compile', coffee )
  .add( 52, 'coffeescript-sourcemaps-write', sourcemaps.write )
