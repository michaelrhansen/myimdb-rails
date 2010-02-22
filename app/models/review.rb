class Review < ActiveRecord::Base
  belongs_to :movie
  attr_accessor :plot, :tagline, :year, :directors, :writers
  after_save :set_movie_rating
  
  AvailableTypes = [
    :imdb,
    :metacritic,
    :rotten_tomatoes
  ]

  def self.init_with_name(name)
    name = name + search_filters if respond_to?(:search_filters)
    resource = locate(name)
    init_with_url(resource[:url]) if resource
  end
  
  def self.init_with_url(url)
    data = scraper.new(url)
    new(:rating               => data.rating,
        :votes                => data.votes,
        :resource_url         => url,
        :resource_identifier  => get_identifier_from_url(url),
        :body                 => data.plot,
        :plot                 => data.plot,
        :tagline              => data.tagline,
        :year                 => data.year,
        :directors            => data.directors_with_url,
        :writers              => data.writers_with_url)
  rescue Exception=> ex
    p "Unable to generate review for: #{url} because: #{ex.message}"
  end
  
  def update_with_url(url)
    data = self.class.scraper.new(url)
    self.attributes = {
      :rating               => data.rating,
      :votes                => data.votes,
      :resource_url         => url,
      :resource_identifier  => self.class.get_identifier_from_url(url),
      :body                 => data.plot,
      :plot                 => data.plot,
      :tagline              => data.tagline,
      :year                 => data.year,
      :directors            => data.directors_with_url,
      :writers              => data.writers_with_url
    }
  end
  
  def self.locate(name)
    search_result = Myimdb::Search::Google.search_text(name, :restrict_to=> search_scope)[0]
    if search_result
      url   = search_result[:url]
      title = search_result[:title]
      id    = get_identifier_from_url(url)
      { :id=> id, :url=> url, :title=> title }
    end
  end
  
  def dom_class
    self.class.to_s.underscore.split('/').last
  end
  
  def set_movie_rating
    movie.update_attribute("#{self.class.simple_name}_rating", rating)
  end
  
  def self.simple_name
    raise 'not implemented'
  end
end
