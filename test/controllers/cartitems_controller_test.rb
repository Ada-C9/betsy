require "test_helper"

describe CartitemsController do

  describe "create" do
    it "should create a cartitem when a cart does not exit" do
      old_cartitem_count = Cartitem.count
      data = {
        product_id: Product.first.id,
        quantity: 3
      }
      post cartitems_path, params: { cartitem: data }
      Cartitem.count.must_equal old_cartitem_count + 1

    end

    it "should create a cartitem when a cart already exists " do
       data = {
         product_id: Product.first.id,
         quantity: 3
       }
       post cartitems_path, params: { cartitem: data }
       old_cartitem_count = Cartitem.count

       data2 = {
         product_id: Product.last.id,
         quantity: 5
       }
       post cartitems_path, params: {cartitem: data2}
       Cartitem.count.must_equal old_cartitem_count + 1
    end

    it "should not create a cartitem when quantity is missing" do
      old_cartitem_count = Cartitem.count

      data = {
        product_id: Product.first.id,
      }

      post cartitems_path, params: { cartitem: data }

      Cartitem.count.must_equal old_cartitem_count
    end

    it "should not create a new cartitem when another cartitem has the same product" do
      data = {
        product_id: Product.first.id,
        quantity: 3
      }
      post cartitems_path, params: { cartitem: data }

      old_cartitem_count = Cartitem.count

      data2 = {
        product_id: Product.first.id,
        quantity: 5
      }

      post cartitems_path, params: {cartitem: data2}
      Cartitem.count.must_equal old_cartitem_count
    end

    it "should not create a new cartitem when there is no such product" do
      data = {
        product_id: Product.first.id,
        quantity: 3
      }

      post cartitems_path, params: { cartitem: data }

      old_cartitem_count = Cartitem.count

      data2 = {
        product_id: Product.last.id + 100,
        quantity: 5
      }

      post cartitems_path, params: {cartitem: data2}
      flash[:result_text].must_equal "It was not possible to add this product to the cart"

    end

  end

  describe "update" do
    it "can update quantity if there is enough stock" do
      cartitem = Cartitem.first
      old_quantity = cartitem.quantity
      new_cartitem_info = { quantity: (old_quantity - 1) }
      patch cartitem_path(cartitem), params: { cartitem: new_cartitem_info }

      must_respond_with :redirect
      must_redirect_to cart_path(cartitem.cart)
      Cartitem.first.quantity.must_equal (old_quantity - 1)
    end


    it "does not update quantity if there is not enough stock" do
      cartitem = Cartitem.first
      old_quantity = cartitem.quantity
      new_cartitem_info = { quantity: 100 }

      patch cartitem_path(cartitem), params: { cartitem: new_cartitem_info }

      must_respond_with :redirect
      must_redirect_to cart_path(cartitem.cart)
      Cartitem.first.quantity.must_equal old_quantity
    end

    it "does not update the DB for bogus data" do
      cartitem = Cartitem.first
      old_quantity = cartitem.quantity
      new_cartitem_info = { quantity: -1 }

      patch cartitem_path(cartitem), params: { cartitem: new_cartitem_info }

      must_respond_with :redirect
      must_redirect_to cart_path(cartitem.cart)
      Cartitem.first.quantity.must_equal old_quantity
    end
  end


  describe "destroy" do
    it "succeeds for an existing cartitem ID" do
      item = Cartitem.first
      item_id = item.id
      old_item_count = Cartitem.count

      delete cartitem_path(item_id)

      Cartitem.count.must_equal old_item_count - 1
      must_respond_with :redirect
      must_redirect_to cart_path(item.cart_id)
    end

    it "renders not_found and does not update the DB for a bogus cartitem ID" do
      item_id = Cartitem.last.id + 1
      old_item_count = Cartitem.count

      delete cartitem_path(item_id)

      Cartitem.count.must_equal old_item_count
      must_respond_with :not_found
    end
  end
end
