xml.instruct! :xml, :version => '1.0', :encoding => 'utf-8'
xml.feed :xmlns => 'http://www.w3.org/2005/Atom' do
  xml.title @title
  xml.subtitle @subtitle
  @posts.each do |post|
    xml.entry do
      xml.title post.title
      xml.link "http://#{@domain}/#{post.url}"
      xml.id "http://#{@domain}/#{post.url}" 
      xml.updated post.date
      xml.body parse(post.body)
    end
  end
end
