class HomepageController < ApplicationController
  def index
    @popular_products = Product.top_sellers
    category_outfit = Category.find_by(name: "outfit")
    @outfits = category_outfit.products
    category_food = Category.find_by(name: "food")
    @foods = category_food.products
    @categories = Category.all

  end
end
