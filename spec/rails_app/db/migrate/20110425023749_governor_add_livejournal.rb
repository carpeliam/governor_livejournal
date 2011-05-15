class GovernorAddLivejournal < ActiveRecord::Migration
  def self.up
    change_table :articles do |t|
      t.boolean :is_livejournal
      t.string :livejournal_security, :default => 'public'
      t.references :livejournal
    end
  end

  def self.down
    change_table :articles do |t|
      t.remove :is_livejournal
      t.remove :livejournal_security
      t.remove :livejournal_id
    end
  end
end
