require "test_helper"

describe Product do
  let(:product) { Product.new }
  let(:p) { products(:product_1)}

  describe "relations" do
    it "has an user" do
      p.must_respond_to :user
      p.user.must_be_kind_of User
      p.user.must_equal users(:user_1)
    end
  end

  describe "validations" do
    it "must be valid" do
      # value(product).must_be :valid?
    end
  end

end
