#!/usr/bin/env ruby

require 'sinatra'
require 'yaml'
require 'builder'
require 'redcarpet'
require 'nokogiri'
require 'albino'
require 'time'

class BlurghConfig
  def initialize
    @options = YAML.load_file("setup.yaml")
  end

  def title
    @options['title']
  end

  def subtitle
    @options['subtitle']
  end

  def store
    @options['store']
  end

  def clicky
    @options['clicky'].to_s
  end

  def google
    @options['google']
  end
end

class Post
  def initialize(file_path)
    @file = file_path
    @contents = File.readlines(@file, "")
    @data = YAML.load(@contents[0])
  end

  def title
    @data['title']
  end

  def url
    @file.split("/").last.gsub(".md", "")
  end

  def date
    @data['date']
  end

  def body
    @contents.drop(1).join
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

def get_post(post)
  begin
    file = File.readlines(BlurghConfig.new.store + "/" + post + ".md", "")
    header = file[0]
    file.delete_at(0)
    return header, file.join
  rescue Errno::ENOENT
    not_found
  end
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
      pre.replace Albino.colorize(pre.text.rstrip, pre[:lang])
    end
    doc.to_s
  end

  def title
    @title
  end

  def days_ago(num)
    digits = num.to_s
    article_age = DateTime.new(digits[0..3].to_i, digits[4..5].to_i, digits[6..7].to_i)
    now = DateTime.now
    days = (now - article_age).to_i #+ 1
    days < 2 ? "#{days} day ago" : "#{days} days ago"
  end


  def feed
    "<link href=\"feed.xml\" type=\"application/atom+xml\" rel=\"alternate\" title=\"" + @title + "\" />"
  end

  def clicky
    "<script src=\"http://static.getclicky.com/js\" type=\"text/javascript\"></script>
<script type=\"text/javascript\">clicky.init(" + @clicky_id + ");</script>
<noscript>
<p>
  <img alt=\"Clicky\" width=\"1\" height=\"1\" src=\"http://in.getclicky.com/" + @clicky_id + "ns.gif\" />
</p>
</noscript>"
  end

  def google
    "<script type=\"text/javascript\">
      var _gaq = _gaq || [];
      _gaq.push(['_setAccount', '" + @google + "']);
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
  blurgh = BlurghConfig.new
  @title = blurgh.title
  @subtitle = blurgh.subtitle
  @posts = get_posts(blurgh.store)
  builder :feed
end

get '/' do
  blurgh = BlurghConfig.new
  @clicky_id = blurgh.clicky
  @google = blurgh.google
  @title = blurgh.title
  @subtitle = blurgh.subtitle
  @posts = get_posts(blurgh.store)
  haml :index
end

get '/:post' do
  @config, @content = get_post(params[:post])
  post_options = YAML.load(@config)
  blurgh = BlurghConfig.new
  @clicky_id = blurgh.clicky
  @title = blurgh.title
  @post_title = post_options['title']
  @date =  post_options['date']
  haml :post
end


