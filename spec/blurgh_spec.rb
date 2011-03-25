# -*- coding: utf-8 -*-
require 'spec_helper'

describe "blurgh" do
  
  def app
    @app ||= Sinatra::Application
  end

  context "routes and content" do
    before :each do
      YAML.should_receive(:load_file).with("setup.yaml").and_return({"title" => "Naslov", "store" => "posts"}) 
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

  describe "get_posts" do
    it "should return posts" do
      first_article = File.readlines("spec/fixtures/o-kapadokiji.md", "")[1]
      second_article = File.readlines("spec/fixtures/let.md", "")[1]
      YAML.should_receive(:load_file).with("setup.yaml").and_return({"title" => "Naslov", "store" => "spec/fixtures"}) 

      get_posts.should == \
      [[20110325,  {"url" => "let", "title" => "Авионски лет", "body" => "#{second_article}"}],\
       [20110324, {"url" => "o-kapadokiji", "title" => "Кападокија", "body" => "#{first_article}"}]]

    end
  end

end
