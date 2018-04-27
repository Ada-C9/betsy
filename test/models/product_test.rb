require "test_helper"

describe Product do

  it "must be valid" do
    product = Product.first
    result = product.valid?
    result.must_equal true
  end

  describe 'retire logic' do
    describe 'product#retire' do
      it "toggles product.retired boolean to true" do
        product = Product.find_by(retired: false)
        product_id = product.id

        product.retire

        result = Product.find(product_id)

        result.retired.must_equal true
      end
    end

    describe 'product#retired?' do
      it "returns true for retired" do
        product = Product.find_by(retired: false)
        product_id = product.id

        result = product.retired?
        result.must_equal false

        product.retire

        result = Product.find(product_id)

        result.retired?.must_equal true
      end

      it "returns false if not retired" do
        product = Product.find_by(retired: false)
        product_id = product.id

        result = product.retired?

        result.must_equal false
      end
    end
  end


end
