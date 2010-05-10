# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

protected

  # See README.rdoc for info..
  helper_method :offline_mode?
  def offline_mode?
    ARGV.include?('OFFLINE_MODE') ? true : false
  end

end
