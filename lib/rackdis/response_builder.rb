module Rackdis
  class ResponseBuilder
    def initialize(command)
      @command = command.to_sym
    end
    
    def process(args, result)
      response_hash = {
        command: @command.to_s.upcase,
        result: result
      }
      
      case @command
      when :sinterstore
      else
        response_hash[:key] = args[0]
      end
      
      response_hash
    end
  end
end