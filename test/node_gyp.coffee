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

linkBindingGyp = ->
	if !fs.existsSync __dirname + '/support/binding.gyp'
		fs.symlinkSync __dirname + '/support/binding.gyp.original', __dirname + '/support/binding.gyp'

unlinkBindingGyp = ->
	if fs.existsSync __dirname + '/support/binding.gyp'
		fs.unlinkSync __dirname + '/support/binding.gyp'

describe 'grunt-node-gyp', ->
	describe 'configure', ->
		it 'should configure a release build by default', (done) ->
			linkBindingGyp()

			execGruntTask 'configure', (err) ->
				return done(err) if err

				configGypi = fs.readFileSync './build/config.gypi', {encoding: 'utf8'}
				if configGypi.indexOf('"default_configuration": "Release"') < 0
					return done(new Error 'expected config.gypi to be configured for release build')

				done()

		it 'should configure a debug build if the debug option is passed', (done) ->
			linkBindingGyp()

			execGruntTask 'configureDebug', (err) ->
				return done(err) if err

				configGypi = fs.readFileSync './build/config.gypi', {encoding: 'utf8'}
				if configGypi.indexOf('"default_configuration": "Debug"') < 0
					return done(new Error 'expected config.gypi to be configured for debug build')

				done()

		it 'should fail if there is no binding.gyp', (done) ->
			unlinkBindingGyp()

			execGruntTask 'configure', (err) ->
				if err then done() else done(new Error 'expected configure to fail')

	describe 'build', ->
		it 'should build a release build by default', ->
			;

		it 'should build a debug build if the debug option is passed', ->
			;

		it 'should fail if there are no build files', ->
			;

	describe 'clean', ->
		it 'should remove the build directory', ->
			;

	describe 'rebuild', ->
		it 'should rebuild a release build by default', ->
			;

		it 'should rebuild a debug build if the debug option is passed', ->
			;

		it 'should fail if there is no binding.gyp', ->
			;

	describe 'default (no command passed)', ->
		it 'should rebuild a release build by default', ->
			;

		it 'should rebuild a debug build if the debug option is passed', ->
			;

		it 'should fail if there is no binding.gyp', ->
			;
