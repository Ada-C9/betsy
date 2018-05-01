require "test_helper"

describe Category do
  let(:category) { Category.new(name: "accessories") }

  it "must be valid" do
    value(category).must_be :valid?
  end

  it "must be invalid without a name" do
    category = Category.new(name: nil)
    category.wont_be :valid?
  end

end
