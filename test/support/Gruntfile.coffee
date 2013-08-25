# This file isn’t actually part of grunt-node-gyp’s build process. It’s only
# used when running tests.

module.exports = (grunt) ->
	grunt.initConfig
		gyp:
			configure:
				command: 'configure'
			configureDebug:
				command: 'configure'
				options:
					debug: true
			build:
				command: 'build'
			buildDebug:
				command: 'build'
				options:
					debug: true
			clean:
				command: 'clean'
			rebuild:
				command: 'rebuild'
			rebuildDebug:
				command: 'rebuild'
				options:
					debug: true
			default: {}
			defaultDebug:
				options:
					debug: true

	grunt.loadTasks '../../tasks'
