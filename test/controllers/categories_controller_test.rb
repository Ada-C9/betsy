require "test_helper"

describe CategoriesController do
  let (:novelty) { categories(:novelty) }
  let(:merchant) { merchants(:astro) }


  it "should get index" do
    get categories_path
    value(response).must_be :success?
  end

  it "should not let a guest get new" do
    get new_category_path
    must_respond_with :not_found
  end

  it "should let a merchant get new" do
    perform_login(merchant, :github)
    get new_category_path
    must_respond_with :success
  end

  it "should let a merchant create a new category" do
    perform_login(merchant, :github)
    proc { post categories_path, params: {category: {name: "marscrafts"}}}.must_change 'Category.count', 1
    must_respond_with :redirect
  end

  it "should not let a merchant create a new category with bad params" do

    perform_login(merchant, :github)
    proc { post categories_path, params: {category: {name: " "}}}.must_change 'Category.count', 0
    must_respond_with :bad_request
  end

  it "should not let a guest create a new category" do

    proc { post categories_path, params: {category: {name: "novelty"}}}.must_change 'Category.count', 0
    must_respond_with :not_found
  end

  # it "must be a unique category" do
  #   perform_login(merchant, :github)
  #   novelty.name.must_equal "Novelty"
  #   proc { post categories_path, params: {category: {name: "Novelty"}}}.must_change 'Category.count', 0
  # end

end
