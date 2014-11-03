module Rackdis
  class RedisFacade
    def initialize(redis)
      @redis = redis
    end
    
    def call(command, *args)
      respond command.to_s.upcase!, args[0], @redis.send(command, *args)
    end

    end
    end

    private

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
