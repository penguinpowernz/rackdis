module Rackdis
  class RedisFacade
    def initialize(redis)
      @redis = redis
    end

    def get(key)
      value = @redis.get(key)
      respond key, value
    end

    def set(key, value)
      @redis.set(key, value)
      respond key
    end
    end

    private

    def respond(key, value=nil)
      command = caller[0].split("`").pop.sub("'","")
      command.upcase!
      
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
