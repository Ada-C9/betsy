require "test_helper"

describe ProductsOrder do
  let(:products_order) { ProductsOrder.new }

  it "must be valid" do
    value(products_order).must_be :valid?
  end
end
