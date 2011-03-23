require 'spec_helper'

describe "Config" do
  
  describe ".title" do
    it "should return value" do
       YAML.stub!(:load_file).with("setup.yaml").and_return({"title" => "Naslov"}) 
      Config.title.should match("Naslov")
    end
  end

end  
