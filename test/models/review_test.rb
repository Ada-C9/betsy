require "test_helper"

describe Review do
  describe 'validations' do
    before do
      @review = Review.new(rating: 4, product: products(:macaron))
    end

    it 'can be created with all required fields' do
      result = @review.valid?

      result.must_equal true
    end

    it 'is invalid without a rating' do
      @review.rating = nil

      result = @review.valid?

      result.must_equal false
    end

    it 'is invalid without a product' do
      @review.product = nil

      result = @review.valid?

      result.must_equal false
    end

    it 'is invalid when the rating is not an integer' do
      @review.rating = 'four'

      result = @review.valid?

      result.must_equal false
    end

    it 'is invalid when the rating is less than 1' do
      @review.rating = 0

      result = @review.valid?

      result.must_equal false
    end

    it 'is invalid when the rating is greater than 5' do
      @review.rating = 6

      result = @review.valid?

      result.must_equal false
    end
  end

  describe 'relations' do
    it 'has a product' do
      review = reviews(:one)
      review.product.must_equal products(:cheesecake)
    end

    it 'can set the product' do
      review = Review.new(rating: 4)
      review.product = products(:macaron)
      review.product_id.must_equal products(:macaron).id
    end
  end
end
