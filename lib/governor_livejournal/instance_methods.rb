module GovernorLivejournal
  module InstanceMethods
    def post_to_livejournal_in_background
      GovernorBackground.run('livejournal_post', self)
    end
    
    def remove_from_livejournal_in_background
      GovernorBackground.run('livejournal_delete', livejournal_id)
    end
  end
end