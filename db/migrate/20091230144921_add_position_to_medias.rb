class AddPositionToMedias < ActiveRecord::Migration
  def self.up
    add_column :medias, :position, :integer, :default=> 0
  end

  def self.down
    remove_column :medias, :position
  end
end
