class SearchController < ApplicationController
  def index
    search = Search.new(value: params[:value])
    render json: search.search
  end
end
