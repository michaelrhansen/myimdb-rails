class MovieWriter < ActiveRecord::Base
  belongs_to :movie
  belongs_to :writer, :class_name=> 'Person', :foreign_key=> 'person_id', :counter_cache=> "movie_count_as_writer"
  
  def add_metadata_to_writer
    Review::AvailableTypes.each do |review_type|
      if review = movie.send("#{review_type.to_s}_movie_review")
        writer.send("average_#{review_type.to_s}_rating_as_writer=", writer.movies_as_writer.average("#{review_type.to_s}_rating", :conditions=> ["#{review_type.to_s}_rating != ?", 0] || 0))
        writer.save!
      end
    end
  end
end
