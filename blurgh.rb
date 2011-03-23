#!/usr/bin/env ruby

require 'sinatra'
require 'yaml'

module Config
  def self.title
    options["title"]
  end
  
  private
  def self.options
    YAML.load_file("setup.yaml")
  end
end

get '/' do
  Config.title
end
