class Movie < ActiveRecord::Base
  attr_accessor :imdb_id, :imdb_url, :metacritic_url
  
  default_scope :order=> "popularity DESC, movie_statuses_count"

  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :movie_directors, :dependent=> :destroy
  has_many :directors, :through=> :movie_directors
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
    Myimdb::Search::Google.search_images(name, :size=> 'medium')[0..4].collect{ |image| image['url'] }.each do |url|
      Media.create(
        :source_url => url,
        :owner      => self) rescue nil
    end
      
  end
end