require "test_helper"

describe User do

  describe "validations" do

    before do
      @user = User.new(name: "test name", email: "ada@ada.org")
    end

    it "can be created with all required fields" do
      # Act
      result = @user.valid?

      # Assert
      result.must_equal true

    end

    # no title -> fail
    it "is invalid without a name" do
      @user.name = nil
      @user.email = "dandragon@gmail.com"

      result = @user.valid?

      result.must_equal false
    end

    it "is invalid without a name" do
      @user.name = "dan"
      @user.email = nil

      result = @user.valid?

      result.must_equal false
    end

    it "is invalid with a duplicate name" do
      dup_user = User.first
      @user.name = dup_user.name

      result = @user.valid?

      result.must_equal false
    end

    it "is invalid with a duplicate email" do
      dup_user = User.first
      @user.email = dup_user.email

      result = @user.valid?

      result.must_equal false
    end
  end

  describe "relations" do
    before do
      @user = User.new(name: 'test name', email: "ada@ada.org")
    end


    it "connects products and product_ids" do
      # Arrange
      product = Product.first

      # Act
      @user.products << product

      # Assert
      @user.product_ids.must_include product.id
    end
  end

  describe "#deactivate" do
    before do
      @user = User.first
      @product = Product.create!(
        name: "test product",
        stock: 3,
        price: 4.56,
        description: "test description",
        user: @user
      )

    end
    it "returns true if user deactivated" do
      @user.products.count.wont_equal 0

      result = @user.deactivate
      result.must_equal true
    end

    it "reassigns products if user had any" do
      @user.products.count.wont_equal 0

      result = @user.deactivate
      result.must_equal true

      @user.reload
      @product.reload

      @user.products.count.must_equal 0
      @product.user.wont_equal @user
    end

    it "cannot be called if user doesnt exist" do
      user_id = User.last.id + 1
      proc {
        User.find_by(id: user_id).deactivate
      }.must_raise
    end

  end

  describe "avail_prod" do

    before do
      @user = User.create!(name: "test", email: "testemail")
      @product1 = Product.create!(name: "first", price: 2.34, stock:14, user: @user)
      @product2 = Product.create!(name: "second", price: 2.34, stock:14, user: @user)
      @product3 = Product.create!(name: "third", price: 2.34, stock:14, user: @user)
    end

    it "returns an array when user has available products" do

      result = @user.avail_prod

      result.must_be_instance_of Array
      result.length.must_equal 3

    end

    it "returns empty array when user does not have available products" do
      @product1.product_status = "retired"
      @product1.save
      @product2.product_status = "retired"
      @product2.save
      @product3.product_status = "retired"
      @product3.save

      result = @user.avail_prod

      result.must_be_instance_of Array
      result.length.must_equal 0

    end

    it "returns empty array when user doesnt have any products at all" do
      @product1.destroy
      @product2.destroy
      @product3.destroy

      result = @user.avail_prod

      result.must_be_instance_of Array
      result.length.must_equal 0
    end

  end

  describe "soldout_prod" do

    before do
      @user = User.create!(name: "test", email: "testemail")
      @product1 = Product.create!(name: "first", price: 2.34, stock:0, user: @user)
      @product2 = Product.create!(name: "second", price: 2.34, stock:0, user: @user)
      @product3 = Product.create!(name: "third", price: 2.34, stock:0, user: @user)
    end

    it "returns an array when user has soldout products" do
      result = @user.soldout_prod

      result.must_be_instance_of Array
      result.length.must_equal 3
    end

    it "returns empty array when user does not have soldout products" do
      @product1.stock = 3
      @product1.save
      @product2.stock = 3
      @product2.save
      @product3.stock = 3
      @product3.save
      result = @user.soldout_prod

      result.must_be_instance_of Array
      result.length.must_equal 0
    end

    it "returns empty array when user doesnt have any products at all" do
      @product1.destroy
      @product2.destroy
      @product3.destroy

      result = @user.soldout_prod

      result.must_be_instance_of Array
      result.length.must_equal 0
    end

  end

  describe "retired_prod" do
    before do
      @user = User.create!(name: "test", email: "testemail")
      @product1 = Product.create!(name: "first", price: 2.34, stock:0, user: @user, product_status: "retired")
      @product2 = Product.create!(name: "second", price: 2.34, stock:0, user: @user, product_status: "retired")
      @product3 = Product.create!(name: "third", price: 2.34, stock:0, user: @user, product_status: "retired")
    end
    it "returns an array when user has retired products" do

      result = @user.retired_prod

      result.must_be_instance_of Array
      result.length.must_equal 3
    end

    it "returns empty array when user does not have retired products" do
      @product1.product_status = nil
      @product1.save
      @product2.product_status = nil
      @product2.save
      @product3.product_status = nil
      @product3.save
      result = @user.retired_prod

      result.must_be_instance_of Array
      result.length.must_equal 0
    end

    it "returns empty array when user doesnt have any products at all" do
      @product1.destroy
      @product2.destroy
      @product3.destroy

      result = @user.retired_prod

      result.must_be_instance_of Array
      result.length.must_equal 0
    end

  end

end
