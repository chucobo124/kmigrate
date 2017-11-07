class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  USERNAME_PROFILE = ENV['USERNAME_PROFILE']
  PROFILE_API = ENV['PROFILE_API']
end
