require 'spec_helper'

describe "Post" do

  post = {
    "title" => "Post title",
    "url" => "nice-title"
  }

  it { Post.new(post).should be_instance_of(Post) }

  describe ".title" do
    it "should return value" do
      Post.new(post).title.should match(post["title"])
    end
  end

  describe ".url" do
    it "should return value" do
      Post.new(post).url.should match(post["url"])
    end
  end

end
