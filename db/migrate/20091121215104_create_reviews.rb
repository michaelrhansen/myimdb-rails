class CreateReviews < ActiveRecord::Migration
  def self.up
    create_table :reviews do |t|
      t.string  :type
      t.float   :rating
      t.integer :votes, :default=> 1, :null=> false
      t.text    :body
      t.string  :resource_identifier
      t.string  :resource_url
      t.integer :movie_id, :null=> false
      
      t.timestamps
    end
  end

  def self.down
    drop_table :reviews
  end
end
