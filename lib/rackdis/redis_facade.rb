module Rackdis
  class RedisFacade
    attr_reader :redis
    
    def initialize(redis, log)
      @redis = redis
      @log = log
    end
    
    def call(command, args)
      command.downcase!
      valid_command! command
      
      @log.info("redis> #{command} #{args.join(' ')}")
      args = Rackdis::ArgumentParser.new(command).process(args)
      
      @log.debug("API => REDIS: "+{command: command, args: args}.inspect)
      result = @redis.send(command, *args)
      
      return Rackdis::ResponseBuilder.new(command).process(args, result)
    end

    # Pub/Sub
    
    def publish(channel, message)
      @redis.publish(channel, message)
      { success: true, command: :PUBLISH, channel: channel }
    end

    private
    
    def valid_command!(cmd)
    end

    def respond(command, key, value=nil)
      hash = {
        success: true,
        command: command,
        key: key
      }

      hash[:value] = value if value
      hash
    end
  end
end
