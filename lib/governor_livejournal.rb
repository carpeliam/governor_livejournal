require 'governor_livejournal/rails'
require 'governor_livejournal/instance_methods'

livejournal = Governor::Plugin.new('livejournal')

livejournal.register_model_callback do |base|
  base.send :include, GovernorLivejournal::InstanceMethods
  base.after_save :post_to_livejournal_in_background, :unless => Proc.new { |article|
    article.changed.any?{|attribute| !%w(id title description post author_id author_type created_at updated_at).include? attribute }
  }
  base.after_destroy :remove_from_livejournal_in_background
end

Governor::PluginManager.register livejournal

module GovernorLivejournal
  class Configuration
    cattr_accessor :username, :password
  end
  @@config = Configuration.new
  mattr_reader :config
end