require "test_helper"

describe Product do
  describe 'validations' do
    before do
      @merchant = Merchant.first
      @product = Product.new(
        name: 'new product',
        price: 500,
        merchant: @merchant
      )
    end

    it 'can be created with all required fields' do
      result = @product.valid?

      result.must_equal true
    end

    it 'is invalid without a name' do
      @product.name = nil

      result = @product.valid?

      result.must_equal false
    end

    it 'is invalid without a price' do
      @product.price = nil

      result = @product.valid?

      result.must_equal false
    end

    it 'is invalid without a merchant' do
      @product.merchant = nil

      result = @product.valid?

      result.must_equal false
    end

    it 'is invalid if price is not an integer' do
      @product.price = 3.99

      result = @product.valid?

      result.must_equal false
    end

    it 'is invalid if price is less than 0' do
      @product.price = -99

      result = @product.valid?

      result.must_equal false
    end
  end

  describe 'relations' do
    before do
      @product = Product.create!(name: 'something good', price: 99, merchant: Merchant.first)
    end

    it 'connects to cartitem and cartitem_id' do
      cartitem = Cartitem.create!(product: @product, cart: Cart.first, quantity: 2)

      @product.cartitems.must_include cartitem
      @product.cartitem_ids.must_include cartitem.id
    end

    it 'prevents destroying product if there exsists a cartitem' do
      product = products(:cheesecake)

      product.destroy.must_equal false

      product.persisted?.must_equal true
    end


    it 'connects to review and review_id' do
      review = Review.create!(product: @product, rating: 5)

      @product.reviews.must_include review
      @product.review_ids.must_include review.id
    end

    it 'connects to categories and category ids' do
      category = Category.first

      @product.categories << category
      @product.category_ids.must_include category.id
    end

    it 'connects to merchant and merchant_id' do
      product = products(:bonbon)

      product.merchant.must_equal merchants(:wini)
      product.merchant_id.must_equal merchants(:wini).id
    end

    it 'can set the merchant' do
      product = Product.new(name: 'tasty treat', price: 199)
      product.merchant = merchants(:analisa)

      product.merchant_id.must_equal merchants(:analisa).id
    end
  end

  describe 'average_rating method' do
    it 'returns the average of all the ratings on a product' do
      product = products(:cheesecake)

      product.average_rating.must_equal 3
    end

    it 'returns nil when there are no reviews' do
      product = products(:macaron)

      product.average_rating.must_be_nil
    end

    it 'returns the value when there is only one review of the one review' do
      product = products(:bonbon)

      product.average_rating.must_equal 3
    end
  end

  describe 'available? method' do
    it 'returns true if the requested quantity is less than the inventory' do
      product = products(:cheesecake)
      product.stock.must_equal 6

      result = product.available?(5)

      result.must_equal true
    end

    it 'returns true if the requested quantity is equal to the inventory' do
      product = products(:bonbon)
      product.stock.must_equal 10

      result = product.available?(10)

      result.must_equal true
    end

    it 'returns false if the requested quantity is greater than the inventory' do
      product = products(:macaron)
      product.stock.must_equal 19

      result = product.available?(20)

      result.must_equal false
    end
  end

  #TODO: Tests for def new_stock
end
