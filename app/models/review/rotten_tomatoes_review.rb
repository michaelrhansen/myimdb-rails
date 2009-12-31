class Review::RottenTomatoesReview < Review
  cattr_reader :search_scope
  @@search_scope = 'rottentomatoes.com'
  
  def self.get_identifier_from_url(url)
    url.split('/')[-1]
  end
  
  def self.make_url_from_identifier(identifier)
    "http://www.rottentomatoes.com/m/#{identifier}/"
  end
  
  def self.scraper
    Myimdb::Scraper::RottenTomatoes
  end
end