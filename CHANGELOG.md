# Changelog

## 0.12-beta

* refactored the API routes to dedup code, support POST commands
* added arg parser and response builder
* added a batch mode through a post request
* validated commands that come through the redis facade
* allowed running unsafe commands
* allowed force enabling commands
* made the config be setup better
* added some basic specs
* rescued all errors to return 500 (temporary)
* added logging with support for multiple locations/levels
* fixed option merging bugs
* added CORS support
* successfully tested chunked encoded subscribe manually

## 0.6-beta

* used the proper rack commands in the executable script
* allowed options to be loaded from a config file
* allowed options to be specified a the command line
* added support for most set commands (missing `SSCAN`)
* added support for most list commands (missing blocking commands)
* added support for `MGET`
* added support for `PUBLISH`
* added support for `SUBSCRIBE` over a streaming connection

## 0.0.1

* got the server running
* added GET and SET commands