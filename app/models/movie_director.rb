class MovieDirector < ActiveRecord::Base
  belongs_to :movie
  belongs_to :director, :class_name=> 'Person', :foreign_key=> 'person_id', :counter_cache=> "movie_count_as_director"
  
  def add_metadata_to_director
    Review::AvailableTypes.each do |review_type|
      if review = movie.send("#{review_type.to_s}_movie_review")
        director.send("average_#{review_type.to_s}_rating_as_director=", director.movies_as_director.average("#{review_type.to_s}_rating", :conditions=> ["#{review_type.to_s}_rating != ?", 0] || 0))
        director.save!
      end
    end
  end
end
