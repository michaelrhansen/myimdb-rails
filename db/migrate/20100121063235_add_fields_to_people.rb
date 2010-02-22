class AddFieldsToPeople < ActiveRecord::Migration
  def self.up
    remove_column :people, :type
    
    add_column :movies, :imdb_rating, :float, :default=> 0
    add_column :movies, :metacritic_rating, :float, :default=> 0
    add_column :movies, :rotten_tomatoes_rating, :float, :default=> 0
    
    add_column :people, :movie_count_as_director, :float, :default=> 0
    
    add_column :people, :average_rating_as_director, :float, :default=> 0
    add_column :people, :average_imdb_rating_as_director, :float, :default=> 0
    add_column :people, :average_metacritic_rating_as_director, :float, :default=> 0
    add_column :people, :average_rotten_tomatoes_rating_as_director, :float, :default=> 0
    
    add_column :people, :movie_count_as_writer, :float, :default=> 0
    add_column :people, :average_rating_as_writer, :float, :default=> 0
    add_column :people, :average_imdb_rating_as_writer, :float, :default=> 0
    add_column :people, :average_metacritic_rating_as_writer, :float, :default=> 0
    add_column :people, :average_rotten_tomatoes_rating_as_writer, :float, :default=> 0
  end

  def self.down
    add_column :people, :type, :string
    
    remove_column :movies, :imdb_rating
    remove_column :movies, :metacritic_rating
    remove_column :movies, :rotten_tomatoes_rating
    
    remove_column :people, :movie_count_as_director
    remove_column :people, :average_rating_as_director
    remove_column :people, :average_imdb_rating_as_director
    remove_column :people, :average_metacritic_rating_as_director
    remove_column :people, :average_rotten_tomatoes_rating_as_director
    
    remove_column :people, :movie_count_as_writer
    remove_column :people, :average_rating_as_writer
    remove_column :people, :average_imdb_rating_as_writer
    remove_column :people, :average_metacritic_rating_as_writer
    remove_column :people, :average_rotten_tomatoes_rating_as_writer
  end
end
