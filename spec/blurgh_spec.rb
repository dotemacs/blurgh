# -*- coding: utf-8 -*-
require 'spec_helper'

describe "blurgh" do

  before :each do
    YAML.should_receive(:load_file)\
      .and_return({"title" => "Naslov", "store" => "spec/fixtures"})
  end

  def app
    @app ||= Sinatra::Application
  end

  context "routes and content" do

    it "should respond to /" do
      get '/'
      last_response.should be_ok
    end

    context "the index view" do

      it "should have a title" do
        get '/'
        last_response.body.should match("Naslov")
      end

      it "should have a body html elements" do
        get '/'
        last_response.body.should match("<body>")
      end

      it "the posts titles should be shown" do
        get '/'
        last_response.body.should match('<a href="let">Авионски лет</a>')
        last_response.body.should match('<a href="o-kapadokiji">Кападокија</a>')
      end

    end

    context "the post view" do
      it "should show post content" do
        get '/let'
        article = File.readlines("spec/fixtures/let.md", "")[1]
        last_response.body.should match(article)
      end

      it "should show post title" do
        get '/let'
        config = File.readlines("spec/fixtures/let.md", "")[0]
        post_options = YAML.load(config)
        last_response.body.should match("Авионски лет")
      end

      it "should show post date" do
        get '/let'
        config = File.readlines("spec/fixtures/let.md", "")[0]
        post_options = YAML.load(config)
        last_response.body.should match("20110325")
      end

    end

    describe "error page" do
      it "should display a pre defined 404 message" do
        get '/non-existent-page'
        last_response.body.should match("Nothing to see here")
      end
    end

  end

  describe "get_posts" do

    it "should return posts" do
      first_article = File.readlines("spec/fixtures/o-kapadokiji.md", "")[1]
      second_article = File.readlines("spec/fixtures/let.md", "")[1]
      store = Config.all['store']

      get_posts(store).should == \
      [[20110325,  {"url" => "let", "title" => "Авионски лет", "body" => "#{second_article}"}],\
       [20110324, {"url" => "o-kapadokiji", "title" => "Кападокија", "body" => "#{first_article}"}]]
    end

  end

  describe "get_post" do

    it "should return a post in two parts" do
      get_post("o-kapadokiji").should have(2).parts
    end

  end

end
