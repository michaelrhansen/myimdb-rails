class Review::MetacriticReview < Review
  cattr_reader :search_scope
  @@search_scope = 'metacritic.com'
  
  def self.get_identifier_from_url(url)
    url.split('/')[-1]
  end
  
  def self.make_url_from_identifier(identifier)
    "http://www.metacritic.com/video/titles/#{identifier}/"
  end
  
  def self.scraper
    Myimdb::Scraper::Metacritic
  end
  
  def search_filters
    'movie'
  end
  
  def self.simple_name
    'metacritic'
  end
end