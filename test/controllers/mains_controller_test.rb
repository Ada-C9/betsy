require "test_helper"

describe MainsController do
  describe "index" do
    it "sends a success response" do

      get root_path

      must_respond_with :success
    end
  end

end
