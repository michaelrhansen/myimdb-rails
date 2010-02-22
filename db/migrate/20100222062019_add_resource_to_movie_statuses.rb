class AddResourceToMovieStatuses < ActiveRecord::Migration
  def self.up
    add_column :movie_statuses, :resource_id, :integer
    add_column :movie_statuses, :resource, :string, :length=> 50
  end

  def self.down
    remove_column :movie_statuses, :resource
    remove_column :movie_statuses, :resource_id
  end
end
