xml.instruct! :xml, :version => '1.0', :encoding => 'utf-8'
xml.feed :xmlns => 'http://www.w3.org/2005/Atom' do
  xml.title @title
  @posts.each do |post|
    xml.entry do
      xml.title
    end
  end
end
