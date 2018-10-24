require "test_helper"

describe MainController do
  it "should get index" do
    get main_index_url
    value(response).must_be :success?
  end

end
