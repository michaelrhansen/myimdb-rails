class AddPopularityAndMovieStatusesCountToMovies < ActiveRecord::Migration
  def self.up
    add_column :movies, :popularity, :integer, :default=> 0
    add_column :movies, :movie_statuses_count, :integer, :default=> 0
  end

  def self.down
    remove_column :movies, :movie_statuses_count
    remove_column :movies, :popularity
  end
end
