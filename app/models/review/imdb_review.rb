class Review::ImdbReview < Review
  cattr_reader :search_scope
  @@search_scope = 'imdb.com'
  
  after_save :fill_parent_details
  
  def self.get_identifier_from_url(url)
    url.split('/')[-1]
  end
  
  def self.make_url_from_identifier(identifier)
    "http://www.imdb.com/title/#{identifier}/"
  end
  
  def self.scraper
    Myimdb::Scraper::Imdb
  end
  
  private
    def fill_parent_details
      movie.update_attributes(:tagline=> tagline, :plot=> plot, :release_year=> year)
    end
end