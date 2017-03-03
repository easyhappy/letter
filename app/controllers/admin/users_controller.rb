class Admin::UsersController < ApplicationController
  def index
    @users = User.ransack(nickname_cont: params[:key]).result.paginate(:page => params[:page] || 1, :per_page => params[:per] || 2)
    params[:total_page] = @users.total_pages
    params[:page]       = params[:page] || 1
  end
end