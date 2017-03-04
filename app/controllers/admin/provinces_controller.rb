class Admin::ProvincesController < ApplicationController
  def index
    @has_search = true
    @provinces = Province.ransack(name_cont: params[:key], country_id_eq: params[:country_id]).result.paginate(:page => params[:page] || 1, :per_page => per_page)
    params[:total_page] = @provinces.total_pages
    params[:page]       = params[:page] || 1
  end
end