module Rackdis
  class API < Grape::API
      
    rescue_from :all do |e|
      error = process_error(e)
      Rack::Response.new({ success: false, error: error.message }.to_json, error.code)
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
        @timer = EM.add_periodic_timer(10) { chunk "" }

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
        
        before_close do
          @timer.cancel
        end

        status 200
        header 'Content-Type', 'application/json'
        ""
      end
      
      def args
        params[:args].split("/")
      end

      def process_error(e)
        Rackdis.logger.e("#{e.class.name}: #{e.message}")
        Rackdis.log_backtrace(e)

        error = {
          code: 500,
          message: e.message
        }

        case e
        when Redis::CommandError
          error.code = 400
        end

        error
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
