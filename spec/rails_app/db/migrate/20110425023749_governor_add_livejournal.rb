class GovernorAddLivejournal < ActiveRecord::Migration
  def self.up
    add_column :articles, :livejournal_id, :integer
  end

  def self.down
    remove_column :articles, :livejournal_id
  end
end
