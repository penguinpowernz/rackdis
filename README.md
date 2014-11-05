# Rackdis

A Ruby clone of the awesome [Webdis](http://webd.is) server, allowing HTTP access to a Redis server through an API.

Webdis is awesome, but it hasn't had much action lately and there are lots of feature requests and bug reports that haven't been addressed.  I would love to contribute but I have no desire in learning C at this stage.  I also think Ruby is awesome so I wanted to try cloning Webdis in Ruby.  Most of the stuff is already written for me, so this project is mostly glue code:

* [Grape](https://github.com/intridea/grape) provides the micro framework necessary to build an API
* [Rack::Stream](https://github.com/intridea/rack-stream) provides the websockets and chunked encoding support
* [Redis-rb](https://github.com/redis/redis-rb) provides the interface to a redis server
* [Thin](https://github.com/macournoyer/thin/) serves it all through rack

As of version `0.6-beta` most of the lists and sets commands are supported as well as `SET`, `GET` and `MGET`.  `PUBLISH` and `SUBSRIBE` is also catered for.  However this code is mostly untested, with specs forthcoming so stuff might not work quite right yet (hence the `-beta`).

**Please see the issues for feature planning and a vauge roadmap.**

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rackdis'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rackdis

## Usage

### Running it

After installing you should be able to run the command `rackdis`. The default port is **7380**.  You can specify the address and port to bind to and daemonize it if you wish:

```sh
rackdis -p 7379 -a 127.0.0.1 -d
```

Or load those options from a config file:

```sh
rackdis -c config.yml
```

Which would look like this:

```yml
---
:port: 7380
:address: 0.0.0.0
:daemonize: false
```

### Accessing it

Each part of the request URL corresponds to any redis command and arguments:

```sh
http://host:port/api-version/command/key[/arg[/arg[...]]
```

Access it by navigating to the endpoint and it will dump out some `json` like so:

```json
# http://localhost:7380/v1/set/hello/world
{
  "success":true,
  "command":"SET",
  "key":"hello"
}
```

```json
# http://localhost:7380/v1/get/hello

{
  "success":true,
  "command":"GET",
  "key":"hello",
  "value":"world"
}
```

## Changelog

Please see the file `CHANGELOG.md`

## Contributing

1. Fork it ( https://github.com/[my-github-username]/rackdis/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
6. If it's all good I'll merge it
