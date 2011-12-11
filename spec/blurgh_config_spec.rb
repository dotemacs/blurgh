require 'spec_helper'

describe "BlurghConfig" do

  describe "#domain" do
    it "should return domain name" do
      domain = "example.com"
      YAML.should_receive(:load_file).with("setup.yaml")
        .and_return({"domain" => domain})
      BlurghConfig.new.domain.should match(domain)
    end
  end


  describe "#title" do
    it "should return value" do
      YAML.should_receive(:load_file).with("setup.yaml").and_return({"title" => "Naslov"})
      BlurghConfig.new.title.should match("Naslov")
    end
  end


  context "when the title is blank" do
    it "should return nothing" do
      YAML.should_receive(:load_file).with("setup.yaml").and_return({"title" => ""})
      BlurghConfig.new.title.should match("")
    end
  end

  context "when the title is missing" do
    it "should return nil" do
      YAML.should_receive(:load_file).with("setup.yaml").and_return({})
      BlurghConfig.new.title.should be_nil
    end
  end

  describe "#subtitle" do
    it "should return value" do
      YAML.should_receive(:load_file).with("setup.yaml").and_return({"subtitle" => "Blurgh blog"})
      BlurghConfig.new.subtitle.should match("Blurgh blog")
    end
  end


  describe "#store" do
    it "should return value" do
      YAML.should_receive(:load_file).with("setup.yaml").and_return({"store" => "posts"})
      BlurghConfig.new.store.should match("posts")
    end
  end

  describe "#paginate" do
    it "should return value" do
      YAML.should_receive(:load_file).with("setup.yaml").and_return({"paginate" => "2"})
      BlurghConfig.new.paginate.should match("2")
    end
  end

  describe "#clicky" do
    before(:each) do
      YAML.should_receive(:load_file).with("setup.yaml").and_return({"clicky" => 123456})
    end

    it "should return value" do
      BlurghConfig.new.clicky.should match("123456")
    end

    it "should return value" do
      BlurghConfig.new.clicky.should be_an_instance_of(String)
    end
  end

  describe "#google" do
    before(:each) do
      YAML.should_receive(:load_file).with("setup.yaml").and_return({"google" => "GO-123-4"})
    end

    it "should return value" do
      BlurghConfig.new.google.should match("GO-123-4")
    end
  end

end
