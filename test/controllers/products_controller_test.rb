require "test_helper"
require 'pry'

describe ProductsController do
  describe 'Index' do
    it 'display all products' do
      get products_path
      must_respond_with :success
    end

    it 'will display all products for a specific category' do
      get products_path,
          params:{
            category:{name: categories(:category_1).name
            }
        }

      #look in to rails spec to confirm that you can see categories
      must_respond_with :success
    end

    it 'will display the associated products to a specific user' do
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
      get product_path(products(:product_4).id)
      must_respond_with :success

      #an existing yml object is showing nil?
    end

    it "will render 404 not found for a product that does not exist" do
      non_existant_id = -100001
      get product_path(non_existant_id)
      must_respond_with :not_found
    end
  end

  describe 'Edit' do
    it 'will provide the populated fields necessary for editing' do
        get edit_product_path(products(:product_4).id)
        must_respond_with :success
        #update to confirm all fields are passing in correctly#
    end

    it 'will render 404 not found for a request to edit a product that does not exist' do
      non_existant_id = -100001
      get edit_product_path(non_existant_id)
      must_respond_with :not_found
    end
  end

  describe 'Update' do
    it 'will allow a user to update an existing product' do

    proc  {patch product_path(products(:product_1).id), params:{
        product:{ name: "new product name",
          is_active: products(:product_1).is_active,
          description: products(:product_1).description,
          price: products(:product_1).price,
          photo_url: products(:product_1).photo_url,
          stock: products(:product_1).stock,
          user_id: users(:user_1).id }
      }}.wont_change 'Product.count'
      must_respond_with :redirect
      must_redirect_to product_path(products(:product_1))

    end

    it 'will render 404 if the product being requested to update does not exist' do
      non_existant_id = -100001
      patch product_path(non_existant_id)
      must_respond_with :not_found
    end

    # it "will not allow other users to update another user's product" do
    #   proc  {patch product_path(products(:product_1)), params:{
    #       product:{ name: "new product name",
    #         is_active: products(:product_2).is_active,
    #         description: products(:product_2).description,
    #         price: products(:product_2).price,
    #         photo_url: products(:product_2).photo_url,
    #         stock: products(:product_2).stock,
    #         user_id: users(:user_1).id }
    #     }}.wont_change 'Product.count'
    #     must_respond_with :redirect
    # end

    it "will not allow a user to update a product with invalid data" do
      proc  {patch product_path(products(:product_1).id), params:{
          product:{ name: "",
            is_active: products(:product_1).is_active,
            description: products(:product_1).description,
            price: products(:product_1).price,
            photo_url: products(:product_1).photo_url,
            stock: products(:product_1).stock,
            user_id: users(:user_1).id }
        }}.wont_change 'Product.count'
        must_respond_with :bad_request
    end

      # it "will not allow a user to modify the amount of stock" do
      #
      # end


  end
  describe 'Set Status' do
    it "an existing product's status can be updated" do
      patch product_set_status_path(products(:product_1).id)
      must_respond_with :found
    end

    it 'a product that does not exist will be sent a 404' do
        non_existant_id = -100001
        patch product_set_status_path(non_existant_id)
        must_respond_with :not_found
    end

  end

###end of class##
end
