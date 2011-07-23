# -*- coding: utf-8 -*-
require 'spec_helper'

describe "blurgh" do

  def app
    @app ||= Sinatra::Application
  end

  context "routes and content" do

    before :each do
      YAML.should_receive(:load_file)\
        .and_return({"title" => "Naslov",
                      "subtitle" => "Blurgh subtitle",
                      "store" => "spec/fixtures",
                      "clicky" => "123456"})
    end

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
        last_response.body.to_s.should \
        match('<link href="feed.xml" type="application/atom\+xml" rel="alternate" title="Naslov')
      end

      context "clicky" do
        it "should have the clicky javascript link" do
          get '/'
          last_response.body.should match('<script src=\"http://static.getclicky.com/js\" type=\"text/javascript\"></script>')
        end
        it "should have the clicky id" do
          get '/'
          last_response.body.should match('clicky.init\(123456\)')
        end
      end
    end

    context "the post view" do
      before :each do
        YAML.should_receive(:load_file)\
          .and_return({"title" => "Naslov",
                        "subtitle" => "Blurgh subtitle",
                        "store" => "spec/fixtures",
                        "clicky" => "123456"})
      end


      it "should show post content" do
        get '/let'
        article = File.readlines("spec/fixtures/let.md", "")
        article.delete_at 0
        last_response.body.should match(Maruku.new(article.join).to_html)
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
        last_response.body.to_s.should \
        match('<link href="feed.xml" type="application/atom\+xml" rel="alternate" title="Naslov')
      end

      it "should format the content" do
        get '/let'
        last_response.body.should match("<strong>this text should be bold</strong>")
      end

      context "clicky" do
        it "should have the clicky javascript link" do
          get '/let'
          last_response.body.should match('<script src=\"http://static.getclicky.com/js\" type=\"text/javascript\"></script>')
        end
        it "should have the clicky id" do
          get '/let'
          last_response.body.should match('clicky.init\(123456\)')
        end
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
      store = BlurghConfig.new.store

      get_posts(store).should == \
      [[20110325,  {"url" => "let", "title" => "Авионски лет", "body" => "#{second_article}"}],\
       [20110324, {"url" => "o-kapadokiji", "title" => "Кападокија", "body" => "#{first_article}"}]]
    end

  end

  describe "get_post" do

    it "should return a post in two parts" do
      get_post("o-kapadokiji").should have(2).parts
    end

    describe "the first part" do
      it "should contain the title and the date" do
        get_post("o-kapadokiji").join.should match("title: Кападокија\ndate: 20110324")
      end
    end

    describe "the second part" do
      it "should contain the contents of the whole page" do
        get_post("o-kapadokiji")[1].should  match('The second paragraph')
      end
    end

  end

end
