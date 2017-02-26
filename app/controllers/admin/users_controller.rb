class Admin::UsersController < ApplicationController
  def index
    @users = User.all.paginate(:page => params[:page] || 1, :per_page => params[:per] || 10)
  end
end