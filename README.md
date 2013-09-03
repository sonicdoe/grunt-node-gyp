# grunt-node-gyp

> Run node-gyp commands from Grunt.

## Getting Started

This plugin requires Grunt `~0.4.0`

If you haven’t used [Grunt](http://gruntjs.com/) before, be sure to check out the [Getting Started](http://gruntjs.com/getting-started) guide, as it explains how to create a [Gruntfile](http://gruntjs.com/sample-gruntfile) as well as install and use Grunt plugins. Once you’re familiar with that process, you may install this plugin with this command:

```shell
$ npm install grunt-node-gyp --save-dev
```

Once the plugin has been installed, it may be enabled inside your Gruntfile with this line of JavaScript:

```js
grunt.loadNpmTasks('grunt-node-gyp');
```

For node-gyp to work you’ll have to install all necessary build tools for your platform, see [node-gyp’s README.md](https://github.com/TooTallNate/node-gyp#installation) for that matter. However, you do not have to install node-gyp globally as it is already included with grunt-node-gyp.

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

Specify node-gyp command to execute.

Supported values are `configure`, `build`, `clean` and `rebuild`. See [node-gyp’s README.md](https://github.com/TooTallNate/node-gyp#commands) for command descriptions.

#### options.debug

Type: `Boolean`
Default value: `false`

Create a debug build.

### Usage Examples

#### Default Options

This would be equivalent to `node-gyp rebuild`.

```shell
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

```shell
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

## Running tests

First, install all dependencies:

```shell
$ npm install
```

Then run the tests:

```shell
$ grunt test
```

Testing might take a while as compiling takes time. You may need to install the node development header files before by executing:

```shell
$ ./node_modules/.bin/node-gyp install
```

## Release History

- v0.1.0: Initial release

## License

`grunt-node-gyp` is licensed under the BSD 2-clause license. See [LICENSE](./LICENSE) for the full license.
