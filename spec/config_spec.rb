require 'spec_helper'

describe "Config" do
  
  describe ".title" do
    it "should return value" do
      YAML.should_receive(:load_file).with("setup.yaml").and_return({"title" => "Naslov"}) 
      Config.title.should match("Naslov")
    end
  end


  context "when the title is blank" do
    it "should return nothing" do
      YAML.should_receive(:load_file).with("setup.yaml").and_return({"title" => ""}) 
      Config.title.should match("")
    end
  end

  context "when the title is missing" do
    it "should return nil" do
      YAML.should_receive(:load_file).with("setup.yaml").and_return({}) 
      Config.title.should be_nil
    end
  end

  describe ".store" do
    it "should return value" do
      YAML.should_receive(:load_file).with("setup.yaml").and_return({"store" => "posts"}) 
      Config.store.should match("posts")
    end
  end

end  
