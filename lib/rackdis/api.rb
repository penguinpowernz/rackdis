module Rackdis
  class API < Grape::API

    version 'v1'
    format :json

    helpers do
      def redis
        @redis ||= RedisFacade.new(Redis.new)
      end
      
      def format_response
      
      end
    end

    get 'get/:key' do
      redis.get params[:key]
    end
    
    get 'set/:key/:value' do
      redis.set params[:key], params[:value]
    end
    
  end
end
    
