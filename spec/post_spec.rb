require 'spec_helper'

describe "Post" do

  post = [20110730, { "url"=>"code", "title"=>"Post title" }]

  it { Post.new(post).should be_instance_of(Post) }

  describe ".title" do
    it "should return title" do
      Post.new(post).title.should match(post[1]["title"])
    end
  end

  describe ".url" do
    it "should return url" do
      Post.new(post).url.should match(post[1]["url"])
    end
  end

  describe ".date" do
    it "should return date" do
      Post.new(post).date.to_s.should match(post[0].to_s)
    end
  end

end
