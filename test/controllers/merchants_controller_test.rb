require "test_helper"

describe MerchantsController do
  it "should get index" do
    get merchants_path

    must_respond_with :success?
  end

  it "should get show" do
    get merchant_path(merchants(:one).id)
    value(response).must_be :success?
  end

  it "should get new" do
    get merchants_new_url
    value(response).must_be :success?
  end

  it "should get create" do
    get merchants_create_url
    value(response).must_be :success?
  end

  it "should get edit" do
    get merchants_edit_url
    value(response).must_be :success?
  end

  it "should get update" do
    get merchants_update_url
    value(response).must_be :success?
  end

  it "should get destroy" do
    get merchants_destroy_url
    value(response).must_be :success?
  end

end
