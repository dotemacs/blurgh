xml.instruct! :xml, :version => '1.0', :encoding => 'utf-8'
xml.feed :xmlns => 'http://www.w3.org/2005/Atom' do
  xml.title @blurgh.title
  xml.subtitle @blurgh.subtitle
  @posts.each do |post|
    xml.entry do
      xml.title post.title
      xml.link "http://#{@blurgh.domain}/#{post.url}"
      xml.id "http://#{@blurgh.domain}/#{post.url}"
      xml.updated post.date
      xml.content parse(post.body), :type => "html"
    end
  end
end
