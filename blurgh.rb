#!/usr/bin/env ruby

require 'sinatra'
require 'yaml'
require 'builder'
require 'maruku'

module Config
  def self.title
    options["title"]
  end

  def self.all
    options
  end

  def self.title
    options["title"]
  end

  def self.subtitle
    options["subtitle"]
  end

  def self.store
    options["store"]
  end

  def self.clicky
    options["clicky"]
  end

  private
  def self.options
    YAML.load_file("setup.yaml")
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
    file = File.readlines(Config.options['store'] + "/" + post + ".md", "")
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

  def clicky(id)
    "<script src=\"http://static.getclicky.com/js\" type=\"text/javascript\"></script>
     <script type=\"text/javascript\">clicky.init(" + id.to_s + ");</script>
     <noscript><p><img alt=\"Clicky\" width=\"1\" height=\"1\" src=\"http://in.getclicky.com/" + id.to_s + "ns.gif\" /></p></noscript>"
  end
end

get '/feed.xml' do
  blurgh_conf = Config.all
  @title = blurgh_conf['title']
  @subtitle = blurgh_conf['subtitle']
  @posts = get_posts(blurgh_conf['store'])
  builder :feed
end

get '/' do
  blurgh_conf = Config.all
  @clicky_id = blurgh_conf['clicky']
  @title = blurgh_conf['title']
  @subtitle = blurgh_conf['subtitle']
  @posts = get_posts(blurgh_conf['store'])
  erb :index
end

get '/:post' do
  @config, @content = get_post(params[:post])
  post_options = YAML.load(@config)
  @title = post_options['title']
  @date =  post_options['date']
  erb :post
end


