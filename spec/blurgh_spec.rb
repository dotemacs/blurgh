# -*- coding: utf-8 -*-
require 'spec_helper'

describe "blurgh" do

  before :each do
    YAML.should_receive(:load_file)\
      .and_return({"title" => "Naslov",
                    "subtitle" => "Blurgh subtitle",
                    "store" => "spec/fixtures"})
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

      it "should have a subtitle" do
        get '/'
        last_response.body.should match("Blurgh subtitle")
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

      it "should have the atom feed link" do
        get '/'
        last_response.body.should =~ /<link\shref=\"feed.xml\"\
\stype=\"application\/atom\+xml\"\srel=\"alternate\"\stitle=\"Naslov\"\s\/>/
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
        last_response.body.should match("Авионски лет")
      end

      it "should show post date" do
        get '/let'
        config = File.readlines("spec/fixtures/let.md", "")[0]
        last_response.body.should match("20110325")
      end

      it "should have the atom feed link" do
        get '/let'
        last_response.body.should =~ /<link\shref=\"feed.xml\"\
\stype=\"application\/atom\+xml\"\srel=\"alternate\"\stitle=\"/
      end
    end

    describe "feed.xml" do
      it "should respond to /feed.xml" do
        get '/feed.xml'
        last_response.should be_ok
      end

      context "format" do
        it "should return XML" do
          get '/feed.xml'
          last_response.headers['Content-Type'].should match("application/xml")
        end

        it "should return XML version" do
          get '/feed.xml'
          last_response.body.to_s.should match("version=\"1.0\"")
        end

        it "should return xmlns" do
          get '/feed.xml'
          last_response.body.to_s.should match("xmlns=\"http:\/\/www.w3.org\/2005\/Atom\"")
        end
      end

      it "should have a title" do
        get '/feed.xml'
        last_response.body.to_s.should match("<title>")
      end

      it "should have a subtitle" do
        get '/feed.xml'
        last_response.body.to_s.should match("<subtitle>")
      end

      context "posts" do
        it "should have posts" do
          get '/feed.xml'
          last_response.body.to_s.should match("<entry>")
        end

        it "should have titles" do
          article = File.readlines("spec/fixtures/let.md", "")[1]
          get '/feed.xml'
          last_response.body.to_s.should =~ /<entry>\n\s+<title>/
        end

        it "should have a link" do
          get '/feed.xml'
          last_response.body.to_s.should match("<link>")
        end

        it "should have a id" do
          get '/feed.xml'
          last_response.body.to_s.should match("<id>")
        end

        it "should have a published time" do
          get '/feed.xml'
          last_response.body.to_s.should match("<updated>")
        end

        it "should have post body" do
          get '/feed.xml'
          last_response.body.to_s.should match("<body>")
        end
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
