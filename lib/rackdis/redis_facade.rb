module Rackdis
  class RedisFacade
    attr_reader :redis
    
    def initialize(redis, config, log)
      @redis  = redis
      @config = config
      @log    = log
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
      raise ArgumentError, "Unsupported command: #{command}" unless valid_command?
    end
    
    def valid_command?(cmd)
      safe_commands.include?(cmd) or
      (@config[:allow_unsafe] and unsafe_commands.include?(cmd)) or
      (@config[:force_enable] and @config[:force_enable].include?(cmd))
    end
    
    def safe_commands
      [
        :ping, :echo, :dbsize, :time,
        :persist, :expire, :expireat, :ttl, :pexpire, :pexpireat, :pttl, :dump, :restore,
        :set, :setex, :psetex, :setnx, :mset, :msetnx, :setrange, :append,
        :get, :getset, :mget, :getrange,
        :getbit, :setbit, :bitcount, :bitop, :bitpos,
        :incr, :incrby, :incrbyfloat, :decr, :decrby, :del, :exists, :keys, :randomkey, :rename, :renamex, :sort, :type, :strlen, :scan,
        :lpush, :lpushx, :rpush, :rpushx, :lrange, :lindex, :linsert, :llen, :lpop, :rpop, :rpoplpush, :lrem, :lset, :ltrim,
        :sadd, :scard, :smembers, :sismember, :srem, :sinter, :sinterstore, :sdiff, :sdiffstore, :sunion, :sunionstore, :spop, :srandmember, :smove, :sscan,
        :zcard, :zadd, :zincrby, :zrem, :zscore, :zrange, :zrevrange, :zrank, :zrevrank, :zremrangebyrank, :zrangebylex, :zrangebyscore, :zrevrangebyscore, :zremrangebyscore, :zcount, :zinterstore, :zunionstore, :zsan,
        :hlen, :hset, :hsetnx, :hmset, :hget, :hmget, :hdel, :hexists, :hincrby, :hincrbyfloat, :hkeys, :hvals, :hgetall, :hscan,
        :publish,
        :pfadd, :pfcount, :pfmerge
      ]
    end
    
    def unsafe_commands
      [
        :auth, :info, :slowlog,
        :bgrewriteaof, :bgsave, :lastsave, :save,
        :config, :flushall, :flushdb,
        :move, :migrate, :select, :slaveof,
        :script, :eval, :evalsha
      ]
    end

    # TODO: investigate and support these
    # def unsupported_commmands
    #   [
    #     :monitor,
    #     :unsubscribe, :psubscribe, :punsubscribe,
    #     :brpop, :blpop, :brpoplpush
    #   ]
    # end

  end
end
