#!/usr/bin/env ruby

require 'sinatra'
require 'yaml'
require 'builder'
require 'maruku'

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
    @options['clicky']
  end
end


def get_posts(store)

  all_posts = Hash.new {
    |h,k| h[k] = Hash.new(&h.default_proc)
  }

  post_dir = File.join(store + "/" + "*.md")

  Dir.glob(post_dir).each do |post|
    header, body = File.readlines(post, "")
    data = YAML.load(header)
    all_posts[data['date']]['url']   = post.gsub("\.md", "").gsub(store + "/", "")
    all_posts[data['date']]['title'] = data['title']
    all_posts[data['date']]['body']  = body
  end

  all_posts.sort.reverse

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
    Maruku.new(content).to_html
  end

  def feed
    "<link href=\"feed.xml\" type=\"application/atom+xml\" rel=\"alternate\" title=\"" + @title + "\" />"
  end

  def clicky
    "<script src=\"http://static.getclicky.com/js\" type=\"text/javascript\"></script>
     <script type=\"text/javascript\">clicky.init(" + @clicky_id + ");</script>
     <noscript><p><img alt=\"Clicky\" width=\"1\" height=\"1\" src=\"http://in.getclicky.com/" + @clicky_id + "ns.gif\" /></p></noscript>"
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
  @title = blurgh.title
  @subtitle = blurgh.subtitle
  @posts = get_posts(blurgh.store)
  erb :index
end

get '/:post' do
  @config, @content = get_post(params[:post])
  post_options = YAML.load(@config)
  blurgh = BlurghConfig.new
  @clicky_id = blurgh.clicky
  @title = blurgh.title
  @post_title = post_options['title']
  @date =  post_options['date']
  erb :post
end


