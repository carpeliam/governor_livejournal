require 'livejournal'
module GovernorLivejournal
  class Livejournal
    include ::LiveJournal
    def initialize(article_or_entry_id)
      @article = article_or_entry_id
      @user = User.new(GovernorLivejournal.config.username, GovernorLivejournal.config.password)
      login = Request::Login.new(@user)
      login.run
    end
  
    def post
      entry = populate_entry(Entry.new)
      post_event = Request::PostEvent.new(@user, entry)
      post_event.run
      entry.itemid
    end
    
    def get
      get_events = Request::GetEvents.new(@user, :itemid => livejournal_id)
      get_events.run
    end
    
    def put
      entry = populate_entry(get)
      edit_event = Request::EditEvent.new(@user, entry)
      edit_event.run
      entry.itemid
    end
    
    def delete
      delete_event = Request::EditEvent.new(@user, get, :delete => true)
      delete_event.run
    end
  
    private
    def livejournal_id
      @article.respond_to?(:livejournal_id) ? @article.livejournal_id : @article
    end
    
    def populate_entry(entry)
      entry.subject = @article.title
      entry.event = Governor::Formatters.format_article @article
      entry.time = LiveJournal::coerce_gmt(@article.created_at.present? ? @article.created_at : Time.now)
      entry.preformatted = false
      entry.security = @article.livejournal_security.to_sym
      entry
    end
  end
end