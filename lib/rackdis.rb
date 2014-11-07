require "logger"
require "yaml"
require "json"
require "redis"
require "grape"
require "redis/connection/synchrony"
require "rack/stream"
require "rack/cors"

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

    def allow_unsafe_commands?
      @config[:unsafe] || false
    end
    
    def logger
      @logger ||= create_logger
    end
    
    def create_logger
      logger = Logger.new @config[:log] || STDOUT
      
      if @config
        logger.level = case @config[:log_level]
        when "debug"
          Logger::DEBUG
        when "info"
          Logger::INFO
        when "error"
          Logger::ERROR
        when "warn"
          Logger::WARN
        else
          Logger::UNKNOWN # shutup!
        end
      else
        logger.log_level = Logger::UNKNOWN
      end
      
      logger
    end
  end
end
