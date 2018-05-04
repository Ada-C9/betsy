require "test_helper"

describe User do


  it "must be valid" do
    value(users(:ada)).must_be :valid?
  end
end
