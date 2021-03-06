class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_current_user

  def set_current_user
    User.current = current_user
  end

  def after_sign_in_path_for(resource)
	  request.env['omniauth.origin'] || root_path
	end
end
