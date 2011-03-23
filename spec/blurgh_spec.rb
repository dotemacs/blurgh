require 'spec_helper'

describe "blurgh" do
  
  def app
    @app ||= Sinatra::Application
  end

  before :each do
    YAML.stub!(:load_file).with("setup.yaml").and_return({"title" => "Naslov"})     
  end

  it "should respond to /" do
    get '/'
    last_response.should be_ok
  end

  it "should have a title" do
    get '/'
    last_response.body.should match("Naslov")
  end

  context "the view" do
    it "should have a body html elements" do
      get '/'
      last_response.body.should match("<body>")
    end
  end


end
