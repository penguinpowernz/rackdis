module Rackdis
  class RedisFacade
    attr_reader :redis
    
    def initialize(redis)
      @redis = redis
    end
    
    def call(command, *args)
      respond command.to_s.upcase!, args[0], @redis.send(command, *args)
    end

    def mget(keys)
      values = @redis.mget(keys)
      
      pairs = {}
      values.each_with_index do |value, i|
        pairs[keys[i]] = value
      end
      
      {
        success: true,
        command: :MGET,
        keys: keys,
        value: values,
        pairs: pairs
      }
    end
    

    # Pub/Sub
    
    def publish(channel, message)
      @redis.publish(channel, message)
      { success: true, command: :PUBLISH, channel: channel }
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
