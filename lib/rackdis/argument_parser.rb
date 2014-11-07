module Rackdis
  class ArgumentParser
    def initialize(command)
      @command = command.to_sym
    end
    
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
