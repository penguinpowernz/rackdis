require "redis"
require "grape"
require "yaml"
require "rack/stream"
require "redis/connection/synchrony"

require "rackdis/version"
require "rackdis/api"
require "rackdis/redis_facade"
require "rackdis/config"
require "rackdis/argument_parser"
require "rackdis/response_builder"

module Rackdis
  class << self
    attr_reader :config
    
    def configure(**opts)
      @config = Rackdis::Config.new(opts)
    end
    
    def rack_options
      {
        Port: @config[:port],
        Host: @config[:address],
        daemonize: @config[:daemonize]
      }
    end
    
    def redis_options
      {
        db: @config[:db] || 0
      }
    end
    
    def redis_client
      Redis.new redis_options
    end
  end
end
