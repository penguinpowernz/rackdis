module Rackdis
  class API < Grape::API

    version 'v1'
    format :json

    helpers do
      def redis
        @redis ||= Redis.new
      end
      
      def format_response
      
      end
    end

    get 'get/:key' do
      value = redis.get params[:key]
      
      {
        success: true,
        command: :GET,
        key: params[:key]
        value: value
      }
    end
    
    get 'set/:key/:value' do
      redis.set params[:key], params[:value]
    
      {
        success: true,
        command: :SET,
        key: params[:key]
      }
    end
    
  end
end
    
