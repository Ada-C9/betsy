require "test_helper"

describe Buyerdetail do
  let(:buyerdetail) { Buyerdetail.new }

  it "must be valid" do
    value(buyerdetail).must_be :valid?
  end
end
