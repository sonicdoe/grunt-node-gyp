module.exports = (grunt) ->
	grunt.initConfig
		clean:
			package: ['tasks/gyp.js']
			test: ['test/support/build']
		coffee:
			task:
				options:
					bare: true
				files:
					'tasks/gyp.js': 'tasks/gyp.coffee'
		mochacli:
			options:
				bail: true
				compilers: ['coffee:coffee-script']
				# Compiling takes time…
				timeout: 8000
			files: ['test/']
	
	grunt.loadNpmTasks 'grunt-contrib-clean'
	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-mocha-cli'

	grunt.registerTask 'package', ['coffee:task']
	grunt.registerTask 'test', ['clean:test', 'mochacli']

	grunt.registerTask 'default', []
