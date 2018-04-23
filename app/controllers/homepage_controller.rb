class HomepageController < ApplicationController
  def index
    @popular_products = Product.top_sellers
    category_outfit = Category.find_by(name: "Outfit")
    @outfits = category_outfit.products
    category_toy = Category.find_by(name: "Toys")
    @toys = category_toy.products
    @categories = Category.all
  end
end
