module Rackdis
  class API < Grape::API
      
    version 'v1'
    format :json

    helpers do
      include Rack::Stream::DSL
      
      def redis
        @redis ||= RedisFacade.new(Redis.new)
      end
      
      def key
        params[:key]
      end
      
      def keys
        params[:keys]
      end
      
      def value
        params[:value]
      end
      
      def values
        params[:values]
      end
    end

    get 'get/:key' do
      redis.call :get, params[:key]
    end
    
    get 'set/:key/:value' do
      redis.call :set, params[:key], params[:value]
    end
    
    get '/mget/*keys' do
      redis.mget params[:keys].split("/")
    end
    
    # Lists
    get 'lpush/:key/:value' do
      redis.call :lpush, key, value
    end
    
    get 'lpush/:key/*values' do
      redis.call :lpush, key, values
    end
    
    get 'lpushx/:key/:value' do
      redis.call :lpushx, key, value
    end
    
    get 'rpush/:key/:value' do
      redis.call :rpush, key, value
    end
    
    get 'rpush/:key/*values' do
      redis.call :rpush, key, values
    end
    
    get 'rpushx/:key/:value' do
      redis.call :rpushx, key, value
    end
    
    get 'llen/:key' do
      redis.call :llen, key
    end
    
    get 'lindex/:key/:index' do
      redis.call :lindex, key, params[:index]
    end
    
    get 'lrange/:key/:start/:stop' do
      redis.call :lrange, key, params[:start], params[:stop]
    end
    
    get 'lset/:key/:index/:value' do
      redis.call :lset, key, params[:index], value
    end
    
    get 'lrem/:key/:count/:value' do
      redis.call :lrem, key, params[:count], value
    end
    
    get 'linsert/:key/:where/:pivot/:value' do
      redis.call :linsert, key, params[:where], params[:pivot], value
    end
    
    get 'lpop/:key' do
      redis.call :lpop, key
    end
    
    get 'rpop/:key' do
      redis.call :rpop, key
    end
    
    get 'rpoplpush/:src/:dst' do
      redis.call :rpoplpush, params[:src], params[:dst]
    end
    
    # Sets
    get 'sadd/:key/*members' do
      redis.call(:sadd, params[:key], params[:members].split("/"))
    end
    
    get 'srem/:key/*members' do
      redis.call(:srem, params[:key], params[:members].split("/"))
    end
    
    get 'smembers/:key' do
      redis.call(:smembers, params[:key])
    end
    
    get 'sismember/:key/:member' do
      redis.call(:sismember, params[:key], params[:member])
    end
    
    get 'scard/:key' do
      redis.call(:scard, params[:key])
    end
    
    get 'smove/:src/:dst/:member' do
      redis.call(:smove, params[:src], params[:dst], params[:member])
    end
    
    get 'spop/:key' do
      redis.call(:spop, params[:key])
    end
    
    get 'srandmember/:key' do
      redis.call(:srandmember, params[:key])
    end
    
    get 'srandmember/:key/:count' do
      redis.call(:srandmember, params[:key], params[:count])
    end
    
    get 'sunion/*keys' do
      redis.call(:sunion, params[:keys].split("/"))
    end
    
    get 'sunionstore/:dst/*keys' do
      redis.call(:sunionstore, params[:dst], params[:keys].split("/"))
    end
    
    get 'sinter/*keys' do
      redis.call(:sinter, params[:dst], params[:keys].split("/"))
    end
    
    get 'sinterstore/:dst/*keys' do
      redis.call(:sinterstore, params[:dst], params[:keys].split("/"))
    end
    
    get 'sdiff/*keys' do
      redis.call(:sdiff, params[:dst], params[:keys].split("/"))
    end
    
    get 'sdiffstore/:dst/*keys' do
      redis.call(:sdiffstore, params[:dst], params[:keys].split("/"))
    end
    
    # Pub/Sub
    
    get 'publish/:channel/:message' do
      redis.publish(params[:channel], params[:message])
    end
    
    get 'subscribe/:channel' do
      after_open do
        redis.redis.subscribe params[:channel] do |on|
          on.message do |channel, msg|
            chunk msg
          end
        end
      end
      
      status 200
      header 'Content-Type', 'application/json'
      ""
    end
  end
end