require 'rails/generators'
require 'rails/generators/migration'
module Governor
  class AddLivejournalGenerator < Rails::Generators::Base
    include Rails::Generators::Migration
    source_root File.expand_path('../templates', __FILE__)
    argument :resource, :type => :string, :default => Governor.default_resource.plural.to_s
  
    def self.next_migration_number(dirname)
      if ActiveRecord::Base.timestamped_migrations
        Time.new.utc.strftime("%Y%m%d%H%M%S")
      else
        "%.3d" % (current_migration_number(dirname) + 1)
      end
    end
  
    def create_migration_file
      migration_template 'migrations/add_livejournal.rb', "db/migrate/governor_add_livejournal.rb", :skip => true
    end
    
    def copy_initializer
      template 'livejournal.rb', 'config/initializers/livejournal.rb'
    end
    
    private
    def mapping
      Governor.resources[resource.pluralize.to_sym]
    end
  end
end