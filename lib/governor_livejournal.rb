require 'governor_livejournal/rails'
require 'governor_livejournal/livejournal'
require 'governor_livejournal/instance_methods'

livejournal = Governor::Plugin.new('livejournal')

livejournal.register_model_callback do |base|
  base.send :include, GovernorLivejournal::InstanceMethods
  base.after_save :post_to_livejournal_in_background, :if => Proc.new { |article|
    article_properties     = %w(title description post)
    livejournal_properties = %w(is_livejournal livejournal_security)
    article.is_livejournal &&
    article.changed.any?{|attribute| (article_properties + livejournal_properties).include? attribute }
  }
  base.after_destroy :remove_from_livejournal_in_background
end
livejournal.register_partial :bottom_of_form, 'articles/livejournal_form'

Governor::PluginManager.register livejournal

GovernorBackground.register('livejournal_post') do |article|
  lj = GovernorLivejournal::Livejournal.new(article)
  id = if article.livejournal_id.blank?
    lj.post
  else
    lj.put
  end
  article.reload.update_attribute :livejournal_id, id
end

GovernorBackground.register('livejournal_delete') do |livejournal_id|
  lj = GovernorLivejournal::Livejournal.new(livejournal_id)
  lj.delete
end

module GovernorLivejournal
  class Configuration
    cattr_accessor :username, :password
  end
  @@config = Configuration.new
  mattr_reader :config
end