#!/usr/bin/env ruby

require 'sinatra'
require 'yaml'

module Config
  def self.all
    options
  end

  def self.title
    options["title"]
  end

  def self.store
    options["store"]
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

get '/' do
  blurgh_conf = Config.all
  @title = blurgh_conf['title']
  @posts = get_posts(blurgh_conf['store'])
  erb :index 
end
