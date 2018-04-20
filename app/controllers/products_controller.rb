class ProductsController < ApplicationController
  def index
    @products = Product.all

    # @category_1 = Product.where(category:category_1)

    # @category_2 = Product.where(category:category_2)

    # TODO: ADD AS MANY CATEGORY FILTERS AS WINI DEVELOPS
  end

  def show
    @product = Product.find(params[:id])
  end
end
