class Review < ActiveRecord::Base
  belongs_to :movie
  attr_accessor :plot, :tagline, :year

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
        :year                 => data.year)
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
      :year                 => data.year
    }
  end

  def self.locate(name)
    search_result = Myimdb::Search::Google.search_text(name, :restrict_to=> search_scope)[0]
    if search_result
      url   = search_result['url']
      title = search_result['titleNoFormatting']
      id    = get_identifier_from_url(url)
      { :id=> id, :url=> url, :title=> title }
    end
  end
  
  def dom_class
    self.class.to_s.underscore.split('/').last
  end
end
