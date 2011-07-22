xml.instruct! :xml, :version => '1.0', :encoding => 'utf-8'
xml.feed :xmlns => 'http://www.w3.org/2005/Atom' do
  xml.title @title
  @posts.each do |post|
    xml.entry do
      xml.title post[1]['title'].to_s
      xml.link post[1]['url'].to_s
      xml.id post[1]['url'].to_s # TODO: add the proper ID along with the domain
      xml.updated post[0].to_s
      xml.body post[1]['body'].to_s
    end
  end
end
