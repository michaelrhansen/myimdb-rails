class AddResourceToActivities < ActiveRecord::Migration
  def self.up
    add_column :activities, :resource_id, :integer
    add_column :activities, :resource_type, :string, :limit=> 50
  end

  def self.down
    remove_column :activities, :resource_type
    remove_column :activities, :resource_id
  end
end
