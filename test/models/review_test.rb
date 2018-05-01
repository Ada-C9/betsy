require "test_helper"

describe Review do
  describe 'validations' do
    it "creates a review with complete form data" do
      product_id = Product.first.id
      old_review_count = Review.count

      review = Review.new(rating: 5, description: 'test review', product_id: product_id )
      review.save

      review.valid?.must_equal true
      Review.count.must_equal old_review_count + 1
      Review.last.description.must_equal 'test review'
    end

    it "rejects a review with non-numeric rating" do
      product_id = Product.first.id
      old_review_count = Review.count

      review = Review.new(rating: '10', description: 'test review', product_id: product_id )
      review.save

      review.valid?.must_equal false
      Review.count.must_equal old_review_count
    end

    it "rejects a review without description" do
      product_id = Product.first.id
      old_review_count = Review.count

      review = Review.new(rating: 1, product_id: product_id )
      review.save

      review.valid?.must_equal false
      Review.count.must_equal old_review_count
    end

    it "rejects a review without rating" do
      product_id = Product.first.id
      old_review_count = Review.count

      review = Review.new(description: 'test review', product_id: product_id )
      review.save

      review.valid?.must_equal false
      Review.count.must_equal old_review_count
    end

    it "rejects review with rating less than 1" do
      product_id = Product.first.id
      old_review_count = Review.count

      review = Review.new(rating: 0, description: 'test review', product_id: product_id )
      review.save

      review.valid?.must_equal false
      Review.count.must_equal old_review_count
    end

    it "rejects review with rating greater than 5" do
      product_id = Product.first.id
      old_review_count = Review.count

      review = Review.new(rating: 6, description: 'test review', product_id: product_id )
      review.save

      review.valid?.must_equal false
      Review.count.must_equal old_review_count
    end
  end


  it "connects merchant and merchant_id" do
    merchant = Merchant.first
    product = Product.find_by(merchant_id: Merchant.first.id)

    product.must_respond_to :merchant
    product.merchant_id.must_equal merchant.id
    product.merchant.must_be_kind_of Merchant
  end


  describe 'relations' do
    it "must respond to product" do
      review = Review.first

      review.must_respond_to :product
      review.product.must_be_kind_of Product
    end
  end
end
