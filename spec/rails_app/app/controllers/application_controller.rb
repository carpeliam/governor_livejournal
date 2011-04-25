class ApplicationController < ActionController::Base
  include GovernorBackground::Controllers::Methods
  protect_from_forgery
end
