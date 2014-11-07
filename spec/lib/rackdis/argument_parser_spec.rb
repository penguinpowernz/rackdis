require 'spec_helper'

describe Rackdis::ArgumentParser do
  subject(:parser) { Rackdis::ArgumentParser.new(command) }
  
  
  describe "PUBLISH" do
    let(:command) { "publish" }
    
    it "should not modify the correct number of args" do
      inn = ["channel", "hi there"]
      out = parser.process(inn)
      expect(out).to eq inn
    end
    
    it "should join the message args together" do
      inn = ["channel", "she was about 18", "19"]
      out = parser.process(inn)
      expect(out.size).to eq 2
      expect(out[1]).to eq "she was about 18/19"
    end
  end
end