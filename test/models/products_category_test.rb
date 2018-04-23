require "test_helper"

describe ProductsCategory do
  let(:products_category) { ProductsCategory.new }

  it "must be valid" do
    value(products_category).must_be :valid?
  end
end
