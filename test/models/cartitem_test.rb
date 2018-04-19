require "test_helper"

describe Cartitem do
  let(:cartitem) { Cartitem.new }

  it "must be valid" do
    value(cartitem).must_be :valid?
  end
end
