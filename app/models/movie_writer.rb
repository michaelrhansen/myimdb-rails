class MovieWriter < ActiveRecord::Base
  belongs_to :movie
  belongs_to :writer, :class_name=> 'Person', :foreign_key=> 'person_id'#, :counter_cache=> "movie_count_as_director"
end
