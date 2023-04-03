class ApplicationController < ActionController::Base
  add_flash_types :info, :error
  helper_method :current_user

  def current_user
    @_current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
