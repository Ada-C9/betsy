require "test_helper"

describe HomepageController do
  it "Index" do
    get homepage_path
    must_respond_with :success
  end
end
