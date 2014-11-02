# Rackdis

A Ruby clone of the awesome Webdis server, allowing HTTP access to a Redis server.

Currently this is just a proof of concept supporting only GET and SET commands.  I intend to make the API resemble the Webdis API as much as possible so the two are interchangeable.

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

After installing you should be able to run the command `rackdis` to start it on port **7380**.

Then access it by navigating to the endpoint and it will dump out some `json` like so:


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

Please see the file CHANGELOG.md

## Contributing

1. Fork it ( https://github.com/[my-github-username]/rackdis/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
6.
