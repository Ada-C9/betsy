require "test_helper"

describe CartitemsController do

  describe "create" do

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
