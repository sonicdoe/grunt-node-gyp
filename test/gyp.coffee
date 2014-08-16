should = require('chai').should()
proxyquire = require 'proxyquire'
fs = require 'fs'

gruntError = null

gruntFailStub = {}
gruntFailStub.warn = gruntFailStub.fatal = (e, errcode) ->
	gruntError = e

# Silent some Grunt output.
gruntLogStub = {}
gruntLogStub.header = ->
gruntLogStub.writeln = -> return { success: -> }

grunt = proxyquire 'grunt', {
	'./grunt/fail': gruntFailStub,
	'./grunt/log': gruntLogStub
}

gruntOptions =
	gruntfile: __dirname + '/support/Gruntfile.coffee'

execGruntTask = (task, callback) ->
	grunt.tasks 'gyp:' + task, gruntOptions, ->
		callback(gruntError)
		gruntError = null

# Windows only allows administrators to create symlinks by default,
# so we create a hardlink instead.
createLink = (srcpath, dstpath) ->
	if require('os').platform() is 'win32'
		fs.linkSync srcpath, dstpath
	else
		fs.symlinkSync srcpath, dstpath

linkBindingGyp = ->
	if !fs.existsSync __dirname + '/support/binding.gyp'
		createLink __dirname + '/support/binding.gyp.original', __dirname + '/support/binding.gyp'

unlinkBindingGyp = ->
	if fs.existsSync __dirname + '/support/binding.gyp'
		fs.unlinkSync __dirname + '/support/binding.gyp'

rmBuildFiles = ->
	# Even though there are more build files than config.gypi we just delete
	# config.gypi as that is sufficient for testing purposes
	if fs.existsSync __dirname + '/support/build/config.gypi'
		fs.unlinkSync __dirname + '/support/build/config.gypi'

describe 'grunt-node-gyp', ->
	describe 'configure', ->
		it 'should configure a release build by default', (done) ->
			linkBindingGyp()

			execGruntTask 'configure', (err) ->
				return done(err) if err

				configGypi = fs.readFileSync './build/config.gypi', 'utf8'
				if configGypi.indexOf('"default_configuration": "Release"') < 0
					return done(new Error 'expected config.gypi to be configured for release build')

				done()

		it 'should configure a debug build if the debug option is passed', (done) ->
			linkBindingGyp()

			execGruntTask 'configureDebug', (err) ->
				return done(err) if err

				configGypi = fs.readFileSync './build/config.gypi', 'utf8'
				if configGypi.indexOf('"default_configuration": "Debug"') < 0
					return done(new Error 'expected config.gypi to be configured for debug build')

				done()

		it 'should fail if there is no binding.gyp', (done) ->
			unlinkBindingGyp()

			execGruntTask 'configure', (err) ->
				if err then done() else done(new Error 'expected configure to fail')

	describe 'build', ->
		it 'should build a release build by default', (done) ->
			linkBindingGyp()

			execGruntTask 'configure', (err) ->
				return done(err) if err
				
				execGruntTask 'build', (err) ->
					return done(err) if err

					if !fs.existsSync './build/Release/hello_world.node'
						return done(new Error 'expected Release/hello_world.node to exist')

					done()

		it 'should build a debug build if the debug option is passed', (done) ->
			linkBindingGyp()

			execGruntTask 'configure', (err) ->
				return done(err) if err

				execGruntTask 'buildDebug', (err) ->
					return done(err) if err

					if !fs.existsSync './build/Debug/hello_world.node'
						return done(new Error 'expected Debug/hello_world.node to exist')

					done()

		it 'should fail if there are no build files', (done) ->
			rmBuildFiles()

			execGruntTask 'build', (err) ->
				if err then done() else done(new Error 'expected build to fail')

	describe 'clean', ->
		it 'should remove the build directory', (done) ->
			execGruntTask 'clean', (err) ->
				return done(err) if err

				if fs.existsSync './build/'
					return done(new Error 'expected build directory to be removed')

				done()

	describe 'rebuild', ->
		it 'should rebuild a release build by default', (done) ->
			linkBindingGyp()

			execGruntTask 'rebuild', (err) ->
				return done(err) if err

				if !fs.existsSync './build/Release/hello_world.node'
					return done(new Error 'expected Release/hello_world.node to exist')

				done()

		it 'should rebuild a debug build if the debug option is passed', (done) ->
			linkBindingGyp()

			execGruntTask 'rebuildDebug', (err) ->
				return done(err) if err

				if !fs.existsSync './build/Debug/hello_world.node'
					return done(new Error 'expected Debug/hello_world.node to exist')

				done()

		it 'should fail if there is no binding.gyp', (done) ->
			unlinkBindingGyp()

			execGruntTask 'rebuild', (err) ->
				if err then done() else done(new Error 'expected rebuild to fail')

	describe 'default (no command passed)', ->
		it 'should rebuild a release build by default', (done) ->
			linkBindingGyp()

			execGruntTask 'default', (err) ->
				return done(err) if err

				if !fs.existsSync './build/Release/hello_world.node'
					return done(new Error 'expected Release/hello_world.node to exist')

				done()

		it 'should rebuild a debug build if the debug option is passed', (done) ->
			linkBindingGyp()

			execGruntTask 'defaultDebug', (err) ->
				return done(err) if err

				if !fs.existsSync './build/Debug/hello_world.node'
					return done(new Error 'expected Debug/hello_world.node to exist')

				done()

		it 'should fail if there is no binding.gyp', (done) ->
			unlinkBindingGyp()

			execGruntTask 'default', (err) ->
				if err then done() else done(new Error 'expected rebuild to fail')
