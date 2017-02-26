class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_admin_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_user_id_in_cookie

  protected

  def set_user_id_in_cookie
    if current_admin_user
      cookies.signed[:user_id] = current_admin_user.id
    else
      cookies.signed[:user_id] = nil
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in) do |user|
      user.permit(:username, :password)
    end
  end
end
