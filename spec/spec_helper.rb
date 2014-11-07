require 'rack/test'
require 'pry'
require 'ostruct'
require 'bundler/setup'
Bundler.setup

require 'rackdis'

# Set test options
Rackdis.configure(db: 13)

# give a seperate redis connection to the same
# database but use the hiredis driver to stop
# errors about the evma server
def redis_connection
  Redis.new driver: :hiredis, db: 13
end

# Helpers for testing the action api

def app
  Rackdis::API
end

def j2o(json)
  OpenStruct.new(JSON.parse(json))
end