require "test_helper"

describe Orderitem do

  it "must be valid" do
    orderitem = Orderitem.first
    orderitem.must_be :valid?
  end
end
