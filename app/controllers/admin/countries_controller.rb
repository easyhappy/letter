class Admin::CountriesController < ApplicationController
  def index
    @has_search = false
    @countries = Country.ransack(name_cont: params[:key]).result.paginate(:page => params[:page] || 1, :per_page => per_page)
    params[:total_page] = @countries.total_pages
    params[:page]       = params[:page] || 1
  end
end