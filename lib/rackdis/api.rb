module Rackdis
  class API < Grape::API
      
    rescue_from :all do |e|
      Rackdis.logger.error("#{e.class.name}: #{e.message}")
      Rackdis.log_backtrace(e)     
      Rack::Response.new({ success: false, error: e.message }.to_json, 500)
    end
    
    version 'v1'
    format :json

    helpers do
      include Rack::Stream::DSL
      
      def redis
        @redis ||= RedisFacade.new(Rackdis.redis_client, Rackdis.config, Rackdis.logger)
      end
      
      def do_subscribe
        after_open do
          channels = params[:channels].split("/")
          Rackdis.logger.debug "Someone subscribed to #{channels}"
          redis.redis.subscribe(channels) do |on|
            on.message do |channel, msg|
              out = { channel: channel, message: msg }
              Rackdis.logger.debug "Pushing: #{out}"
              chunk out.to_json
            end
          end
        end
        
        status 200
        header 'Content-Type', 'application/json'
        return ""
      end
      
      def args
        params[:args].split("/")
      end
    end
    
    # Subscribe
    get 'subscribe/*channels' do
      do_subscribe
    end
    
    get 'SUBSCRIBE/*channels' do
      do_subscribe
    end

    post 'batch' do
      redis.batch params[:commands]
    end

    get ':command/*args' do
      redis.call params[:command], args
    end
    
    post ':command/*args' do
      redis.call params[:command], args
    end
  end
end
