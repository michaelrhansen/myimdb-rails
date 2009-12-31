class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :username
      t.string :twitter_username, :null=> false, :limit=> 50
      t.string :twitter_id, :null=> false
      t.string :twitter_profile_image
      t.string :twitter_token, :null=> false

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
