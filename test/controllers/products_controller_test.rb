require "test_helper"
require 'pry'

describe ProductsController do
  describe 'Index' do
    it 'display all products' do
      get products_path
      must_respond_with :success
    end
  end

  describe 'New' do
    it 'will display a new product form' do
      get new_user_product_path(users(:user_1).id)
      must_respond_with :success
    end
  end

  describe 'Create' do
    it 'will create a new valid product for a user' do

      proc {
        post user_products_path(users(:user_1).id),
        params:{
          product:{ name: "A Product",
            is_active: true,
            description: "ldkfjsldkfj",
            price: 11,
            photo_url: nil,
            stock: 12,
            user_id: users(:user_1).id}
            }
      }.must_change 'Product.count',1
      must_respond_with :redirect
      must_redirect_to product_path(Product.last.id)

    end

    it 'will not create a product with invalid inputs'do
        proc {
          post user_products_path(users(:user_2).id),
          params:{
            product:{ name: "",
              is_active: products(:product_2).is_active,
              description: products(:product_2).description,
              price: products(:product_2).price,
              photo_url: products(:product_2).photo_url,
              stock: products(:product_2).stock,
              user_id: users(:user_2).id}
              }
        }.wont_change 'Product.count'
        must_respond_with :bad_request
    end

    it 'will not allow a user to create a product for another user ID' do
      proc {
        post user_products_path(users(:user_2).id),
        params:{
          product:{ name: "",
            is_active: products(:product_2).is_active,
            description: products(:product_2).description,
            price: products(:product_2).price,
            photo_url: products(:product_2).photo_url,
            stock: products(:product_2).stock,
            user_id: users(:user_1).id}
            }
      }.wont_change 'Product.count'
      must_respond_with :bad_request

    end
  end

  describe 'Show' do
    it "will display a product's deatil page" do
      get product_path(products(:product_2).id)
    end

    it "will render 404 not found for a product that does not exist" do
    end
  end



###end of class##
end
