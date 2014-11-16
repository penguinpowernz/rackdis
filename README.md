# Rackdis

![](http://i.imgur.com/CDKmIl1.png)

A Ruby clone of the awesome [Webdis](http://webd.is) server, allowing HTTP access to a Redis server through an API.

Webdis is awesome, but it hasn't had much action lately and there are lots of feature requests and bug reports that haven't been addressed.  I would love to contribute but I have no desire in learning C at this stage.  I also think Ruby is awesome so I wanted to try cloning Webdis in Ruby.  Most of the stuff is already written for me, so this project is mostly glue code:

* [Grape](https://github.com/intridea/grape) provides the micro framework necessary to build an API
* [Slop](https://github.com/leejarvis/slop) awesome command line options
* [Rack::Stream](https://github.com/intridea/rack-stream) provides the websockets and chunked encoding support
* [Rack::Cors](https://github.com/cyu/rack-cors) provides cross origin resource sharing
* [Redis-rb](https://github.com/redis/redis-rb) provides the interface to a redis server
* [Thin](https://github.com/macournoyer/thin/) serves it all through rack

Most commands should work, there are a few left unsupported. However this code is mostly untested, with specs forthcoming so stuff might not work quite right yet (hence the `-beta`).  I still have work to do in the Argument Parser and Response Builder area so commands that differ from the classic `COMMAND key [arg]` pattern may not work yet.  In this situation you would see a `NotImplementError` reported.

**Please see the issues for feature planning and a vauge roadmap.**

## Features

* Most commands supported
* Unsafe commands disabled by default
* Pub/sub over streaming connections (chunked encoding/websockets)
* Batch processing of multiple redis commands (MULTI/EXEC anyone?)
* Logging to multiple locations and levels
* Cross Origin Resource Sharing
* Flexible command line operation
* Configuration priority: command line > config file > hard coded defaults

## Todo

* more relevant HTTP codes
* more specs
* figure out what MULTI/EXEC is and how to support it
* a lower level batch mode

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rackdis', '~> 0.12.pre.beta'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rackdis --pre

## Usage

The help screen is a good place to start:

```sh
$ rackdis --help
Usage: rackdis [options]
    -r, --redis               The redis server location (127.0.0.1, :6379, 127.0.0.1:6379)
    -c, --config              Config file to load options from
    -p, --port                Port for rackdis to bind to
    -a, --address             Address for rackdis to bind to
    -d, --daemonize           Put rackdis in the background
        --log_level           Log level (shutup, error, warn, debug, info)
    -l, --log                 Log location (- or stdout for stdout, stderr)
        --db                  The redis db to use (a number 0 through 16)
        --allow_unsafe        Enable unsafe commands (things like flushdb) !CAREFUL!
        --force_enable        Comma separated list of commands to enable !CAREFUL!
        --allow_batching      Allows batching of commands through a POST request
    -h, --help                Display this help message.
```

All of these commands are optional.  The hard coded configuration has sane defaults.  Specifying a configuration file would override those defaults.  Specifying a command line options from above overrides everything.  Speaking of configuration files, here's what one looks like (with the aforementioned sane defaults specified):

```yml
---
:port:           7380
:address:        127.0.0.1
:daemonize:      false
:db:             0
:log:            stdout
:log_level:      info
:allow_unsafe:   false
:force_enable:   false
:allow_batching: false
:redis:          127.0.0.1:6379
```

### Running it

Fully fledged example:

```sh
rackdis -p 7379 -a 127.0.0.1 -d --allow_batching --allow_unsafe -l stderr --log_level debug --redis :6379 --db 4 --force_enable flushdb,move,migrate,select
```

Simply load from a config file:

```sh
rackdis -c config.yml
```

### Call and response

The pattern looks like this: `http://localhost:7379/:version/:command/*args`

* **version** is just the API version (v1)
* **command** is the redis command to run
* everything after that is arguments to the redis command

The response is in JSON and provides some basic information about the request and including the result (of course).

So if I want to get a range from a list: `http://localhost:7380/v1/lrange/shopping_list/4/10`

```json
{
  "success":true,
  "command":"LRANGE",
  "key":"shopping_list",
  "result":[ "milk", "chicken abortions", "prophylactics"]
}
```

Add some members to a set: `http://localhost:7380/v1/sadd/cars/toyota/nissan/dodge`

```json
{
  "success":true,
  "command":"SADD",
  "key":"cars",
  "result":"OK"
}
```

Or just get a value: `http://localhost:7380/v1/get/readings:ph`

```json
{
  "success":true,
  "command":"GET",
  "key":"readings:ph",
  "result":"7.4"
}
```

You get the gist.

### Batching

Batching allows you to get redis to execute a bunch of commands one after the other

```javascript
$.post(
  "http://localhost:7380/v1/batch",
  {
    commands: [
      "SET this that",
      "INCR rickrolls",
      "SUNIONSTORE anothermans:treasure onemans:trash anothermans:treasure"
    ]
  }
)
```

That will return this JSON:

```json
["OK", 45, "OK"]
```

You will need to enable batching explicitly at command line or in the config file.

### Pub/Sub

Publish/Subscribe is supported over chunked encoding and websockets.

More details forthcoming.

Subscribe: `http://localhost:7380/v1/subscribe/messages`

Publish: `http://localhost:7380/v1/publish/messages/hi`

## Changelog

Please see the file `CHANGELOG.md`

## Contributing

1. Fork it ( https://github.com/[my-github-username]/rackdis/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
6. If it's all good I'll merge it
