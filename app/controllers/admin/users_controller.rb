class Admin::UsersController < ApplicationController
  def index
    @has_search = true
    @users = User.ransack(nickname_cont: params[:key]).result.paginate(:page => params[:page] || 1, :per_page => per_page)
    params[:total_page] = @users.total_pages
    params[:page]       = params[:page] || 1
  end
end