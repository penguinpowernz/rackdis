module Rackdis
  class API < Grape::API
      
    version 'v1'
    format :json

    helpers do
      include Rack::Stream::DSL
      
      def redis
        @redis ||= RedisFacade.new(Rackdis.redis_client, Rackdis.logger)
      end
      
      def do_subscribe
        after_open do
          Rackdis.logger.debug "Someone subscribed to #{params[:channel]}"
          redis.redis.subscribe params[:channel] do |on|
            on.message do |channel, msg|
              Rackdis.logger.debug "Pushing: #{msg}"
              chunk msg
            end
          end
        end
        
        status 200
        header 'Content-Type', 'application/json'
        ""
      end
      
      def args
        params[:args].split("/")
      end
    end
    
    # Subscribe
    get 'subscribe/:channel' do
      do_subscribe
    end
    
    get 'SUBSCRIBE/:channel' do
      do_subscribe
    end

    get ':command/*args' do
      redis.call params[:command], args
    end
    
    post ':command/*args' do
      redis.call params[:command], args
    end
  end
end