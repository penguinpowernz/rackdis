module Rackdis
  class ArgumentParser
    def initialize(command)
      @command = command.to_sym
    end
    
    # The point of this method is to turn the given args, coming from
    # the api path, into an array that can be splatted straight into
    # the redis method for the given command.
    def process(args)
      case @command
      when :lpush, :rpush, :sadd, :srem, :sunionstore, :sinterstore, :sdiffstore
        [
          args[0],
          args[1..-1]
        ]
      when :mget, :sunion, :sinter, :sdiff
        [
          args[0..-1]
        ]
      when :publish
        [
          args[0],
          args[1..-1].join("/")
        ]
      else
        args
      end
    end
    
  end
end
