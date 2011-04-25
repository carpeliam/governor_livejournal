require 'spec_helper'

describe GovernorLivejournal do
  it "registers the plugin" do
    Governor::PluginManager.plugins.size == 1
  end
end
