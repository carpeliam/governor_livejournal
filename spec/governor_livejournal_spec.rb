require 'spec_helper'

describe GovernorLivejournal do
  it "registers the plugin" do
    Governor::PluginManager.plugins.size == 1
  end
  
  it "registers a job with GovernorBackground" do
    GovernorBackground.retrieve('livejournal_post').should_not be_blank
  end
  
  it "can post to livejournal" do
    article = get_article
    article.livejournal_id.should == 12345
  end
  
  it "can update livejournal" do
    article = get_article
    lj = mock()
    GovernorLivejournal::Livejournal.expects(:new).with(article).returns lj
    lj.expects(:put).returns 12345
    article.update_attribute :title, "Some new title"
  end
  
  it "can delete from livejournal" do
    article = get_article
    lj = mock()
    GovernorLivejournal::Livejournal.expects(:new).with(12345).returns lj
    lj.expects(:delete)
    article.destroy
  end
  
  def get_article
    article = Factory.build(:article, :is_livejournal => true, :author => Factory(:user))
    lj = mock()
    GovernorLivejournal::Livejournal.expects(:new).with(article).returns lj
    lj.expects(:post).returns 12345
    article.save
    article
  end
end
