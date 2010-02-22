class Movie < ActiveRecord::Base
  attr_accessor :imdb_id, :imdb_url, :metacritic_url
  
  default_scope :order=> "popularity DESC, movie_statuses_count"

  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive=> false

  has_many :movie_directors, :dependent=> :destroy
  has_many :directors, :through=> :movie_directors
  
  has_many :movie_writers, :dependent=> :destroy
  has_many :writers, :through=> :movie_writers
  
  has_many :movie_statuses

  has_many :reviews
  has_one  :imdb_movie_review, :class_name=> 'Review::ImdbReview'
  has_one  :metacritic_movie_review, :class_name=> 'Review::MetacriticReview'
  has_one  :rotten_tomatoes_movie_review, :class_name=> 'Review::RottenTomatoesReview'
  
  has_many :medias, :as=> :owner
  has_many :movie_statuses

  before_validation_on_create :associate_reviews

  accepts_nested_attributes_for :directors
  
  after_create :pull_images
  
  def associate_reviews
    self.imdb_movie_review              = Review::ImdbReview.init_with_name(name)
    self.metacritic_movie_review        = Review::MetacriticReview.init_with_name(name)
    self.rotten_tomatoes_movie_review   = Review::RottenTomatoesReview.init_with_name(name)
  end
  
  def all_reviews
    reviews = self.reviews
    [Review::ImdbReview, Review::MetacriticReview, Review::RottenTomatoesReview].each do |review_type|
      reviews += [review_type.new] unless reviews.detect{ |r| review_type === r }
    end
    reviews
  end
  
  def pull_images
    Myimdb::Search::Google.search_images(name, :size=> 'medium')[0..4].collect{ |image| image[:url] }.each do |url|
      Media.create(
        :source_url => url,
        :owner      => self) rescue nil
    end
  end
  
  def self.locate(options={})
    search_term = options[:q].try(:strip)

    if search_term.blank?
      return Movie.all
    end

    if options[:fuzzy]
      Movie.all(:conditions=> ["name like ? and name != ?", "%#{search_term}%", search_term])
    else
      Movie.all(:conditions=> { :name=> search_term })
    end
  end
  
  # [{ :name=> 'name', :url=> 'imdb_url }]
  def directors=(directors)
    directors.each do |director|
      person          = Person.find_or_initialize_by_name(director[:name])
      person.imdb_url = director[:url]
      person.save
      
      self.movie_directors.create(:director=> person)
    end
  end
  
  # [{ :name=> 'name', :url=> 'imdb_url }]
  def writers=(writers)
    writers.each do |writer|
      person          = Person.find_or_initialize_by_name(writer[:name])
      person.imdb_url = writer[:url]
      person.save
      
      self.movie_writers.create(:writer=> person)
    end
  end
end
