xml.instruct! :xml, :version => '1.0', :encoding => 'utf-8'
xml.feed :xmlns => 'http://www.w3.org/2005/Atom' do
  xml.title @title
  xml.subtitle @subtitle
  @posts.each do |post|
    xml.entry do
      xml.title post.title
      xml.link post.url
      xml.id post.url # TODO: add the proper ID along with the domain
      xml.updated post.date
      xml.body post.body
    end
  end
end
