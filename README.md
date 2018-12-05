# grunt-node-gyp [![Linux build status](https://img.shields.io/travis/sonicdoe/grunt-node-gyp.svg?logo=travis)](https://travis-ci.org/sonicdoe/grunt-node-gyp) [![Windows build status](https://img.shields.io/appveyor/ci/sonicdoe/grunt-node-gyp.svg?logo=appveyor)](https://ci.appveyor.com/project/sonicdoe/grunt-node-gyp)

> Run `node-gyp` commands from Grunt

## Getting started

If you haven’t used [Grunt](https://gruntjs.com) before, be sure to check out the [Getting started](https://gruntjs.com/getting-started) guide, as it explains how to create a [Gruntfile](https://gruntjs.com/sample-gruntfile) as well as install and use Grunt plugins. Once you’re familiar with that process, you may install this plugin with this command:

```console
$ npm install grunt-node-gyp --save-dev
```

Once the plugin has been installed, it may be enabled inside your Gruntfile with this line of JavaScript:

```js
grunt.loadNpmTasks('grunt-node-gyp')
```

You’ll also need to install all necessary build tools. Take a look at [`node-gyp`’s readme](https://github.com/nodejs/node-gyp#installation) for installation instructions. You don’t need to install `node-gyp` globally, however, as it already comes with `grunt-node-gyp`.

## The “gyp” task

### Overview

In your project’s Gruntfile, add a section named `gyp` to the data object passed into `grunt.initConfig()`.

```js
grunt.initConfig({
  gyp: {
    options: {
      // Task-specific options go here.
    },
    your_target: {
      // Target-specific file lists and/or options go here.
    }
  }
})
```

### Options

#### command

Type: `String`
Default value: `rebuild`

`node-gyp` command to execute.

Supported commands are `configure`, `build`, `clean` and `rebuild`. See [node-gyp’s readme](https://github.com/nodejs/node-gyp#commands) for command descriptions.

#### options.debug

Type: `Boolean`
Default value: `false`

Create a debug build.

#### options.arch

Type: `String`
Default value: Your processor’s architecture

Set the target architecture: `ia32`, `x64` or `arm`.

### Usage examples

#### Default options

This would be equivalent to `node-gyp rebuild`.

```console
$ grunt gyp:addon
```

```js
grunt.initConfig({
  gyp: {
    addon: {}
  }
})
```

#### Configure a debug build

This would be equivalent to `node-gyp configure --debug`.

```console
$ grunt gyp:customTarget
```

```js
grunt.initConfig({
  gyp: {
    customTarget: {
      command: 'configure',
      options: {
        debug: true
      }
    }
  }
})
```

#### Build an ARM build

This would be equivalent to `node-gyp build --arch=arm`.

```console
$ grunt gyp:arm
```

```js
grunt.initConfig({
  gyp: {
    arm: {
      command: 'build',
      options: {
        arch: 'arm'
      }
    }
  }
})
```

## Running tests

```console
$ npm install
$ npm test
```

The test suite might take a while as compiling takes time. You may need to install the Node.js header files beforehand:

```console
$ npx node-gyp install
```

## Changelog

This project follows [Semantic Versioning 2](https://semver.org).

- v4.0.0 (2017-07-03):
  - Fix SDK being downloaded to the local directory when using `node-gyp` v3.5 or later
  - Drop support for Node.js versions older than v4
- v3.1.0 (2016-06-19): Add support for Grunt v1
- v3.0.0 (2015-09-08): Update `node-gyp` to v3
- v2.0.0 (2015-05-25): Update `node-gyp` to v2
- v1.0.0 (2015-02-14): Improve clarity of error messages by passing `node-gyp`’s error on
- v0.5.0 (2014-12-02): Add [`arch` option](https://github.com/sonicdoe/grunt-node-gyp#optionsarch)
- v0.4.1 (2014-08-25): Fix rebuild not stopping execution if one of the commands has failed
- v0.4.0 (2014-07-01): Update `node-gyp` to v1
- v0.3.0 (2014-03-05): Update `node-gyp` to v0.13
- v0.2.1 (2014-02-21): Fix borked v0.2.0 release
- v0.2.0 (2013-11-21): Update `node-gyp` to v0.12
- v0.1.0 (2013-08-25): Initial release

## License

`grunt-node-gyp` is licensed under the BSD 2-Clause license. See [`LICENSE`](./LICENSE) for the full license text.
