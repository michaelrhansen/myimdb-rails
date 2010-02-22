class Person < ActiveRecord::Base
  has_many :movie_directors
  has_many :movies_as_director, :through=> :movie_directors, :source=> :movie
  
  has_many :movie_writers
  has_many :movies_as_writer, :through=> :movie_writers, :source=> :movie
  
  # after_save :set_averages
  
  def set_averages
    self.update_attribute(:average_rating_as_director,
      [:average_imdb_rating_as_director,
        :average_metacritic_rating_as_director,
        :average_rotten_tomatoes_rating_as_director].inject(0) { |sum, field| sum += send(field)/3 if send(field) > 0 })
        
    self.update_attribute(:average_rating_as_writer,
      [:average_imdb_rating_as_writer,
        :average_imdb_rating_as_writer,
        :average_rotten_tomatoes_rating_as_writer].inject(0) { |sum, field| sum += send(field)/3 if send(field) > 0 })
  end
end
