class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.string :content
      t.string :type, :limit=> 50
      t.integer :user_id
      t.integer :movie_id

      t.timestamps
    end
  end

  def self.down
    drop_table :activities
  end
end
