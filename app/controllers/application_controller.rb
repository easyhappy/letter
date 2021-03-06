class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_user_id_in_cookie

  protected

  def per_page
    10
  end

  def after_sign_in_path_for user
    "/admin"
  end

  def set_user_id_in_cookie
    if current_user
      cookies.signed[:user_id] = current_user.id
    else
      cookies.signed[:user_id] = nil
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in) do |user|
      user.permit(:name, :password)
    end
  end
end
