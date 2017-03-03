class Admin::ActivitiesController < ApplicationController
  def index
    @has_search = false
    @activities = Activity.paginate(:page => params[:page] || 1, :per_page => per_page)
    params[:total_page] = @activities.total_pages
    params[:page]       = params[:page] || 1
  end
end