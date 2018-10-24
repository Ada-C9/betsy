require "test_helper"

describe Product do
  describe "relations" do
    before do
      @first_user = User.first
      @product = Product.first
      @product.user = @first_user
    end

    it "connects to user and user id" do
      @product.user_id.must_equal @first_user.id
    end

    it "has a list of categories" do
      @product.categories << categories(:sleepy)
      @product.must_respond_to :categories

      @product.categories.each do |category|
        category.must_be_kind_of Category
      end
    end

    it "has a list of reviews" do
      @product.must_respond_to :reviews

      @product.reviews << reviews(:one)
      @product.reviews.each do |review|
        review.must_be_kind_of Review
      end

      #review cant belong to two items
    end
  end

  describe "validations" do
    before do
      @user = User.first
      @category = Category.first

      @product = Product.new(user: @user, name: "test product", price: 12.99, stock: 5, product_status:nil)
    end


    it 'can be created with all valid fields' do
      result = @product.valid?
      result.must_equal true
    end

    it 'is invalid without a user' do
      @product.user = nil
      result = @product.valid?
      result.must_equal false
      @product.errors.messages.must_include :user
    end

    it 'is invalid without a product name' do
      @product.name = nil
      result = @product.valid?
      result.must_equal false
      @product.errors.messages.must_include :name
    end

    it 'is invalid if the user has duplicate product name' do
      @product.save
      dup_name = @product.name
      dup_product = Product.new(user: @user, name: dup_name, price: 10.60, stock: 6)
      # dup_product.name = dup_name

      result = dup_product.valid?
      result.must_equal false
      dup_product.errors.messages.must_include :name
    end

    it 'is invalid if no price' do
      @product.price = nil
      result = @product.valid?
      result.must_equal false
      @product.errors.messages.must_include :price
    end

    it 'is invalid if price is less than zero' do
      @product.price = -7.0
      result = @product.valid?
      result.must_equal false
      @product.errors.messages.must_include :price
    end

    it 'is invalid if price is not a number' do
      @product.price = "hello"
      result = @product.valid?
      result.must_equal false
      @product.errors.messages.must_include :price
    end

    # it 'must belong to an existing category' do
    # end

    it 'is invalid if no stock number provided' do
      #make sure only an integer is accepted/returned
      @product.stock = nil
      result = @product.valid?
      result.must_equal false
      @product.errors.messages.must_include :stock
    end

    it 'is invalid if stock is less than zero' do
      @product.stock = -9
      result = @product.valid?
      result.must_equal false
      @product.errors.messages.must_include :stock
    end

    it 'is invalid if stock is a float' do
      @product.stock = 9.50
      result = @product.valid?
      result.must_equal false
      @product.errors.messages.must_include :stock
    end

    it 'allows two users to have the same product name??' do
      user_two = User.last
      user_two.wont_equal @user

      @product.save
      dup_name = @product.name
      dup_product = Product.new(user: user_two, name: dup_name, price: 10.60, stock: 6)

      result = dup_product.valid?
      result.must_equal true
    end

    it 'is valid with product-status' do
      @product.product_status = 'retired'

      a = @product.valid?

      a.must_equal true
    end

  end
end
