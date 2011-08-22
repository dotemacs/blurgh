#!/usr/bin/env ruby

require 'sinatra'
require 'yaml'
require 'builder'
require 'redcarpet'
require 'nokogiri'
require 'pygments.rb'
require 'time'

class BlurghConfig
  attr_reader :domain, :title, :subtitle, :store, :clicky, :google

  def initialize
    options = YAML.load_file("setup.yaml")
    @domain = options['domain']
    @title = options['title']
    @subtitle = options['subtitle']
    @store = options['store']
    @clicky = options['clicky'].to_s
    @google = options['google']
  end
end

class Post
  attr_reader :title, :date, :url, :body

  def initialize(file_path)
    contents = File.readlines(file_path, "")
    data = YAML.load(contents[0])
    @title = data['title']
    @date = data['date']
    @url = file_path.split("/").last.gsub(".md", "")
    @body = contents.drop(1).join
  end
end

def get_posts(store)

  all_posts = Array.new
  post_dir = File.join(store + "/" + "*.md")
  count = 0

  Dir.glob(post_dir).each do |file|
    @post = Post.new(file)
    all_posts[count] = @post
    count += 1
  end

  all_posts.sort{|a,b| a.date <=> b.date}.reverse

end

not_found do
  "Nothing to see here"
end

helpers do
  def parse(content)
    syntax_highlighter(Redcarpet.new( content,
                                      :fenced_code,
                                      :gh_blockcode,
                                      :hard_wrap ).to_html )
  end

  def syntax_highlighter(html)
    doc = Nokogiri::HTML(html)
    doc.search("//pre[@lang]").each do |pre|
      pre.replace Pygments.highlight(pre.text.rstrip, :lexer => pre[:lang])
    end
    # '\n' is REQUIRED for correct formatting
    doc.to_s.gsub("<pre>", "<pre>\n")
  end

  def days_ago(num)
    digits = num.to_s
    article_age = DateTime.new(digits[0..3].to_i, digits[4..5].to_i, digits[6..7].to_i)
    now = DateTime.now
    days = (now - article_age).to_i #+ 1
    days < 2 ? "#{days} day ago" : "#{days} days ago"
  end


  def feed
    "<link href=\"feed.xml\" type=\"application/atom+xml\" rel=\"alternate\" title=\"" + @blurgh.title + "\" />"
  end

  def clicky
    "<script src=\"http://static.getclicky.com/js\" type=\"text/javascript\"></script>
<script type=\"text/javascript\">clicky.init(" + @blurgh.clicky + ");</script>
<noscript>
<p>
  <img alt=\"Clicky\" width=\"1\" height=\"1\" src=\"http://in.getclicky.com/" + @blurgh.clicky + "ns.gif\" />
</p>
</noscript>"
  end

  def google
    "<script type=\"text/javascript\">
      var _gaq = _gaq || [];
      _gaq.push(['_setAccount', '" + @blurgh.google + "']);
      _gaq.push(['_trackPageview']);
       (function() {
        var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
        ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
        var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
       })();
    </script>"
  end

end

get '/feed.xml' do
  @blurgh = BlurghConfig.new
  @posts = get_posts(@blurgh.store)
  builder :feed
end

get '/' do
  @blurgh = BlurghConfig.new
  @posts = get_posts(@blurgh.store)
  haml :index
end

get '/:post' do
  begin
    @blurgh = BlurghConfig.new
    @post = Post.new(@blurgh.store + "/" + params[:post] + ".md")
    haml :post
  rescue Errno::ENOENT
    not_found
  end
end


