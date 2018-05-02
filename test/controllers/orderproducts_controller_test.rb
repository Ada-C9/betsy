require "test_helper"

describe OrderproductsController do
  it "should get index" do
    get orderproducts_path

    must_respond_with :success
  end

  it "should get show" do
    get orderproduct_path(Orderproduct.first.id)

    must_respond_with :success
  end

  describe "create" do
    it "should increase ordperproduct count" do
      before = Orderproduct.all.count

      newop = Orderproduct.create_orderproduct(products(:candy).quantity, products(:candy).id, orders(:open).id)
      newop.save

      Orderproduct.all.count.must_equal before +1
    end
  end

  it "should get new" do
    get new_orderproduct_path

    must_respond_with :success
  end

  it "should get edit" do
    get edit_orderproduct_path(Orderproduct.last.id)
    get edit_orderproduct_path(Orderproduct.first.id)

    must_respond_with :success
  end

  describe "update" do
    it "successfully update field with valid id" do
      updated_quantity = 6

      patch orderproduct_path(Orderproduct.first.id),
      params: {
        orderproduct: {
          quantity: updated_quantity,
        }
      }

      updated_op = Orderproduct.find(Orderproduct.first.id)
      updated_op.quantity.must_equal updated_quantity
    end
  end

  describe "destroy" do
    it "deletes a orderproduct" do
      delete orderproduct_path(Orderproduct.first.id)

      must_respond_with :redirect
    end

    it "reduces orderproduct count" do
      initial = Orderproduct.count

      delete orderproduct_path(Orderproduct.first.id)

      Orderproduct.count.must_equal initial - 1

    end
  end

  describe "clear cart" do
    # it "should delete orderproducts from order" do
    #   orderproducts(:one).clear_cart
    #
    #   must_respond_with :redirect
    #   must_redirect_to orderproducts_path
    # end
  end

end
