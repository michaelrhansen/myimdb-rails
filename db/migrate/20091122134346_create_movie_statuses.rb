class CreateMovieStatuses < ActiveRecord::Migration
  def self.up
    create_table :movie_statuses do |t|
      t.integer :movie_id
      t.integer :status_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :movie_statuses
  end
end
