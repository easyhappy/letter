class UsersController < ApplicationController
  def index
    @users = User.users_without_me(current_user).paginate(:page => params[:page] || 1, :per_page => params[:per] || 10)
  end
end