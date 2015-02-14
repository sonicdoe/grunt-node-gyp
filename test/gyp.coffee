should = require('chai').should()
fs = require 'fs'
exec = require('child_process').exec
path = require 'path'

supportDir = path.join __dirname, 'support'

execOptions =
	cwd: supportDir

execGruntTask = (task, callback) ->
	exec "grunt gyp:#{task}", execOptions, (error, stdout, stderr) ->
		callback error, stdout, stderr

# Windows only allows administrators to create symlinks by default,
# so we create a hardlink instead.
createLink = (srcpath, dstpath) ->
	if require('os').platform() is 'win32'
		fs.linkSync srcpath, dstpath
	else
		fs.symlinkSync srcpath, dstpath

linkBindingGyp = ->
	if !fs.existsSync path.join(supportDir, 'binding.gyp')
		createLink path.join(supportDir, 'binding.gyp.original'), path.join(supportDir, 'binding.gyp')

unlinkBindingGyp = ->
	if fs.existsSync path.join(supportDir, 'binding.gyp')
		fs.unlinkSync path.join(supportDir, 'binding.gyp')

rmBuildFiles = ->
	# Even though there are more build files than config.gypi we just delete
	# config.gypi as that is sufficient for testing purposes
	if fs.existsSync path.join(supportDir, 'build', 'config.gypi')
		fs.unlinkSync path.join(supportDir, 'build', 'config.gypi')

describe 'grunt-node-gyp', ->
	# Set timeout to 120 seconds as compiling may take a long time.
	@timeout (120 * 1000)

	describe 'configure', ->
		it 'should configure a release build by default', (done) ->
			linkBindingGyp()

			execGruntTask 'configure', (err) ->
				return done(err) if err

				configGypi = fs.readFileSync path.join(supportDir, 'build', 'config.gypi'), 'utf8'
				if configGypi.indexOf('"default_configuration": "Release"') < 0
					return done(new Error 'expected config.gypi to be configured for release build')

				done()

		it 'should configure a debug build if the debug option is passed', (done) ->
			linkBindingGyp()

			execGruntTask 'configureDebug', (err) ->
				return done(err) if err

				configGypi = fs.readFileSync path.join(supportDir, 'build', 'config.gypi'), 'utf8'
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

					if !fs.existsSync path.join(supportDir, 'build', 'Release', 'hello_world.node')
						return done(new Error 'expected Release/hello_world.node to exist')

					done()

		it 'should build a debug build if the debug option is passed', (done) ->
			linkBindingGyp()

			execGruntTask 'configure', (err) ->
				return done(err) if err

				execGruntTask 'buildDebug', (err) ->
					return done(err) if err

					if !fs.existsSync path.join(supportDir, 'build', 'Debug', 'hello_world.node')
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

				if fs.existsSync path.join(supportDir, 'build')
					return done(new Error 'expected build directory to be removed')

				done()

	describe 'rebuild', ->
		it 'should rebuild a release build by default', (done) ->
			linkBindingGyp()

			execGruntTask 'rebuild', (err) ->
				return done(err) if err

				if !fs.existsSync path.join(supportDir, 'build', 'Release', 'hello_world.node')
					return done(new Error 'expected Release/hello_world.node to exist')

				done()

		it 'should rebuild a debug build if the debug option is passed', (done) ->
			linkBindingGyp()

			execGruntTask 'rebuildDebug', (err) ->
				return done(err) if err

				if !fs.existsSync path.join(supportDir, 'build', 'Debug', 'hello_world.node')
					return done(new Error 'expected Debug/hello_world.node to exist')

				done()

		it 'should fail if there is no binding.gyp', (done) ->
			unlinkBindingGyp()

			execGruntTask 'rebuild', (err) ->
				if err then done() else done(new Error 'expected rebuild to fail')

	describe 'arch option', ->
		it 'should build a 32-bit build if specified', (done) ->
			linkBindingGyp()

			execGruntTask 'archIa32', (err) ->
				return done(err) if err

				configGypi = fs.readFileSync path.join(supportDir, 'build', 'config.gypi'), 'utf8'
				if configGypi.indexOf('"target_arch": "ia32"') < 0
					return done(new Error 'expected config.gypi to be configured for 32-bit build')

				done()

		it 'should build a 64-bit build if specified', (done) ->
			linkBindingGyp()

			execGruntTask 'archX64', (err) ->
				return done(err) if err

				configGypi = fs.readFileSync path.join(supportDir, 'build', 'config.gypi'), 'utf8'
				if configGypi.indexOf('"target_arch": "x64"') < 0
					return done(new Error 'expected config.gypi to be configured for 64-bit build')

				done()

		it 'should build an ARM build if specified', (done) ->
			linkBindingGyp()

			execGruntTask 'archArm', (err) ->
				return done(err) if err

				configGypi = fs.readFileSync path.join(supportDir, 'build', 'config.gypi'), 'utf8'
				if configGypi.indexOf('"target_arch": "arm"') < 0
					return done(new Error 'expected config.gypi to be configured for ARM build')

				done()

	describe 'default (no command passed)', ->
		it 'should rebuild a release build by default', (done) ->
			linkBindingGyp()

			execGruntTask 'default', (err) ->
				return done(err) if err

				if !fs.existsSync path.join(supportDir, 'build', 'Release', 'hello_world.node')
					return done(new Error 'expected Release/hello_world.node to exist')

				done()

		it 'should rebuild a debug build if the debug option is passed', (done) ->
			linkBindingGyp()

			execGruntTask 'defaultDebug', (err) ->
				return done(err) if err

				if !fs.existsSync path.join(supportDir, 'build', 'Debug', 'hello_world.node')
					return done(new Error 'expected Debug/hello_world.node to exist')

				done()

		it 'should fail if there is no binding.gyp', (done) ->
			unlinkBindingGyp()

			execGruntTask 'default', (err) ->
				if err then done() else done(new Error 'expected rebuild to fail')
