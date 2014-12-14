module Rackdis
  class ResponseBuilder
    def initialize(command)
      @command = command.to_sym
    end
    
    def process(args, result)
      r = {
        command: @command.to_s.upcase,
        result: result
      }
      
      case @command
      when :sinterstore, :sdiffstore, :sunionstore
        r[:destination]  = args.first
        r[:keys]         = args[1]
      when :mget
        r[:keys]         = args[0]
        r[:pairs]        = {}
        args.each_with_index do |key, index|
          r[:pairs][key] = result[index]
        end
      when :sismember
        r[:key]          = args.first
        r[:member]       = args[1]
      when :srandmember
        r[:key]          = args.first
        r[:count]        = args[1]
      when :sdiff, :sunion, :sinter
        r[:keys]         = args[0]
      when :smove
        r[:source]       = args[0]
        r[:destination]  = args[1]
        r[:member]       = args[2]
      when :srem, :sadd
        r[:key]          = args.first
        r[:members]      = args[1]
      else
        r[:key]          = args.first
      end
      
      r
    end
  end
end