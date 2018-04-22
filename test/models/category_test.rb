require "test_helper"

describe Category do
  describe "valid" do
    it "must be valid" do
      categories(:novelty).must_be :valid?
    end

    it "must have at least one character" do
      new_category = Category.create(name: "")
      new_category.valid?.must_equal false
      new_category.errors.must_include :name

      Category.create(name: "         ").valid?.must_equal false

      Category.create(name: nil).valid?.must_equal false

      Category.create().valid?.must_equal false
    end

    it "must have a unique name" do
      new_category = Category.create(name: categories(:novelty).name)
      new_category.valid?.must_equal false
      new_category.errors.must_include :name
    end

    it "must have a unique name regardless of case" do
      new_cat_name = categories(:novelty).name
      new_cat_name[0] = new_cat_name.chr.swapcase

      new_category = Category.create(name: new_cat_name)
      new_category.valid?.must_equal false
      new_category.errors.must_include :name
    end

    it "removes strips white space from name" do
      new_category = Category.create(name: "     Hello      World     ")
      new_category.valid?.must_equal true
      new_category.name.must_equal "Hello World"

    end

    it "strips white space from name before testing validity" do
      Category.create(name: "Foo Bar      ").name.must_equal "Foo Bar"

      # Should be invalid because whitespaces are removed and it's a duplicate
      new_category = Category.create(name: "Foo       Bar")
      new_category.valid?.must_equal false
      new_category.errors.must_include :name

      # Should be invalid because whitespaces are removed and it's a duplicate
      new_category = Category.create(name: "     Foo Bar")
      new_category.valid?.must_equal false
      new_category.errors.must_include :name
    end
  end

  describe "relations" do
    it "has a list of votes" do
      dan = users(:dan)
      dan.must_respond_to :votes
      dan.votes.each do |vote|
        vote.must_be_kind_of Vote
      end
    end
    #
    #   it "has a list of ranked works" do
    #     dan = users(:dan)
    #     dan.must_respond_to :ranked_works
    #     dan.ranked_works.each do |work|
    #       work.must_be_kind_of Work
    #     end
    #   end
    end
  end
