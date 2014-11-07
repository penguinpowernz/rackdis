require 'spec_helper'

describe Rackdis::API do
  include Rack::Test::Methods
  
  subject(:response) { j2o last_response.body }
  let(:r)            { redis_connection }
  let(:key)          { "test:hello" }
  after(:each)       { r.del key }
  
  describe "Key operations" do
    
    describe "GET" do
      it "should give null for unset values" do
        get "/v1/get/#{key}"
        expect(response.result).to eq nil
      end
      
      it "should get a value that is set" do
        r.set(key, "world")
        # pry
        get "/v1/get/#{key}"
        expect(response.result).to eq "world"
      end
    
    end
    
    describe "SET" do
      it "should set a value" do
        get "/v1/set/#{key}/world"
        expect(r.get(key)).to eq "world"
      end
      
      it "should override a key" do
        get "/v1/set/#{key}/world"
        get "/v1/set/#{key}/bob"
        expect(r.get(key)).to eq "bob"
      end
    end
    
    describe "INCR" do
      it "should increment a value" do
        get "/v1/incr/#{key}"
        get "/v1/incr/#{key}"
        get "/v1/incr/#{key}"
        expect(r.get key).to eq "3"
      end
      
      it "should return the incremented value" do
        get "/v1/incr/#{key}"
        get "/v1/incr/#{key}"
        get "/v1/incr/#{key}"
        expect(response.result).to eq 3
      end
    end
  end
  
  describe "Sets operations" do
    
    describe "SMEMBERS" do
      
      context "when there are no memebers" do
        it "should return an empty array" do
          get "/v1/smembers/#{key}"
          expect(response.result).to eq []
        end
      end
      
      context "when there are members" do
        it "should return them" do
          r.sadd key, "world"
          get "/v1/smembers/#{key}"
          expect(response.result).to eq ["world"]
        end
      end
      
    end
    
    describe "SADD" do
      
      it "should add single member" do
        expect { get "/v1/sadd/#{key}/world" }.to change { r.scard key }.by(1)
      end
      
      it "should add multiple members" do
        expect { get "/v1/sadd/#{key}/tom/dick/harry" }.to change { r.scard key }.by(3)
      end
      
    end
  end
end