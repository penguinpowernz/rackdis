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
      redis.call :get, params[:key]
    end
    
    get 'set/:key/:value' do
      redis.call :set, params[:key], params[:value]
    end
    
    
    # Lists
    
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
    
  end
end
    
