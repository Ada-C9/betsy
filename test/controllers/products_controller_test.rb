require "test_helper"
require "pry"

describe ProductsController do
  describe "index" do
    it "succeeds when there are works" do
        Product.count.must_equal 3
        get products_path
        must_respond_with :success
    end

    it "succeeds when there are no works" do
        Product.all.each do |item|
          item.destroy
        end

        Product.count.must_equal 0
        get products_path
        must_respond_with :success
      end
  end

  describe "show" do
    it "succeeds" do
      get product_path(products(:cat))
      must_respond_with :success
    end

    it "redirects if not in db" do
      get product_path("carrot")
      must_redirect_to products_path
    end
  end

  describe "new" do
    it "succeeds" do
      get new_product_path
      must_respond_with :success
    end
  end

  describe "create" do
    it "creates a product with valid data" do
      Product.count.must_equal 3
        proc {
          # login_user(users(:ada))
            post products_path, params: {
              product: {
                name: "Bunny",
                stock: 14,
                price: 5,
                description: "Too many, please help",
                status: true,
                user_id: users(:ada).id,
                image_url: "www.test-URL.com",
                categories: [categories(:one)]
              }
            }
        }.must_change "Product.count", 1
      must_respond_with :redirect
      must_redirect_to products_path
    end

    it "won't create invalid product" do
      proc {
        post products_path, params: {
          product: {
            stock: 14,
            price: 5,
            description: "Too many, please help",
            status: true,
            user_id: users(:ada).id,
            image_url: "www.test-URL.com"
            }
          }
        }.must_change "Product.count", 0

      Product.count.must_equal 3
    end
  end

  describe "edit" do
    it "succeeds for an extant product ID" do
      get edit_product_path(products(:cat).id)
      must_respond_with :success
    end

    # it "renders 404 not_found for a bogus work ID" do
    #   get edit_product_path("carrot")
    #   must_respond_with :not_found
    # end

  end

  describe "update" do
    it "succeeds for valid data and an extant work ID" do
      updated_name = "Donkey"

      put product_path(products(:dragon).id), params: {
        product: {
          name: "Donkey"
        }
      }

      updated_product = Product.find(products(:dragon).id)
      updated_product.name.must_equal updated_name
      must_respond_with :redirect
    end

    it "renders bad_request for bogus data" do
      product = products(:dragon)
      put product_path(product.id), params: {
        product: {
          name: ""
        }
      }

      product.name.must_equal "Norweigan Ridgeback"
    end


    # it "renders 404 not_found for a bogus product ID" do
    #   put product_path(products(:dragon).id), params: {
    #     product: {
    #       id: "deeface"
    #     }
    #   }
    #   must_respond_with :not_found
    # end
  end

end
