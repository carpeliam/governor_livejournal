require 'livejournal'
module GovernorLivejournal
  module InstanceMethods
    def post_to_livejournal
      user = ljlogin
      if livejournal_id.blank?
        entry = populate_entry(LiveJournal::Entry.new)
        post_event = LiveJournal::Request::PostEvent.new(user, entry)
        post_event.run
        
        self.update_attribute :livejournal_id, entry.itemid
      else
        get_events = LiveJournal::Request::GetEvents.new(user, :itemid => livejournal_id)
        entry = populate_entry(get_events.run)
        edit_event = LiveJournal::Request::EditEvent.new(user, entry)
        edit_event.run
      end
    end
    
    def remove_from_livejournal
      user = ljlogin
      get_events = LiveJournal::Request::GetEvents.new(user, :itemid => livejournal_id)
      entry = get_events.run
      delete_event = LiveJournal::Request::EditEvent.new(user, entry, :delete => true)
      delete_event.run
    end
  
    def post_to_livejournal_in_background
      run_in_background :post_to_livejournal
    end
    
    def remove_from_livejournal_in_background
      run_in_background :remove_from_livejournal
    end
    
    private
    def ljlogin
      user = LiveJournal::User.new(GovernorLivejournal.config.username, GovernorLivejournal.config.password)
      login = LiveJournal::Request::Login.new(user)
      login.run
      user
    end
    
    def populate_entry(entry)
      entry.subject = self.title
      entry.event = Governor::Formatters.format_article self
      entry.time = LiveJournal::coerce_gmt(self.created_at.present? ? self.created_at : Time.now)
      entry.preformatted = false
      entry.security = livejournal_security.to_sym
      entry
    end
  end
end