module Rackdis
  class RedisFacade
    def initialize(redis)
      @redis = redis
    end

    def get(key)
      value = @redis.get(key)
      respond :GET, key, value
    end

    def set(key, value)
      @redis.set(key, value)
      respond :SET, key
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
