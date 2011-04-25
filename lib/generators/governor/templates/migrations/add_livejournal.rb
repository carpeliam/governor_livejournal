class GovernorAddLivejournal < ActiveRecord::Migration
  def self.up
    add_column :<%= mapping.plural %>, :livejournal_id, :integer
  end

  def self.down
    remove_column :<%= mapping.plural %>, :livejournal_id
  end
end
