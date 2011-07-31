require 'spec_helper'

describe "Post" do

  post = "spec/fixtures/code.md"

  it { Post.new(post).should be_instance_of(Post) }

  describe ".title" do
    it "should return title" do
      Post.new(post).title.should match("Code")
    end
  end

  describe ".url" do
    it "should return url" do
      Post.new(post).url.should match("code")
    end
  end

  describe ".date" do
    it "should return date" do
      Post.new(post).date.to_s.should match("20110730")
    end
  end

  describe ".body" do
    it "should return the body of the post" do
      body = 'Some code snippets:\n\n```ruby\nputs \"this is ruby code\"\n```'
      Post.new(post).body.to_s.should match(body)
    end
  end


end
