class CategoriesController < ApplicationController
  def index
    @categories = Category.all.paginate(:page => params[:page], :per_page => 3)
  end

  def show
    @category = Category.find_by(id: params[:id])
    head :not_found unless @category
  end
end
