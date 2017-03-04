class Admin::CitiesController < ApplicationController
  def index
    @has_search = true
    @cities = City.ransack(name_cont: params[:key], province_id_eq: params[:province_id], country_id_eq: params[:country_id]).result.paginate(:page => params[:page] || 1, :per_page => per_page)
    params[:total_page] = @cities.total_pages
    params[:page]       = params[:page] || 1
  end
end