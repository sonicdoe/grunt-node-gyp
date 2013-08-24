should = require('chai').should()
proxyquire = require 'proxyquire'

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

describe 'grunt-node-gyp', ->
	describe 'configure', ->
		it 'should configure a release build by default', ->
			;

		it 'should configure a debug build if the debug option is passed', ->
			;

		it 'should fail if there is no binding.gyp', ->
			;

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
