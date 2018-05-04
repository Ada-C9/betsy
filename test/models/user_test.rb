require "test_helper"

describe User do
  let(:user) { User.new }
  let(:one) { users(:one) }

  describe "relations" do
    it "has a list of products" do
      dan = users(:one)
      dan.must_respond_to :products
      dan.products.each do |product|
        product.must_be_kind_of Product
      end
      dan.products.count.must_equal 2
    end

    it "returns an empty array if user does not have products" do
      dan = users(:three)
      dan.must_respond_to :products
      dan.products.each do |product|
        product.must_be_kind_of Product
      end
      dan.products.must_equal []
    end
  end

  describe "validations" do
    it "must be valid" do
      one.must_be :valid?
    end

    it "must have a username" do
      user.email = "email"
      user.username = "   "
      user.valid?.must_equal false
      user.errors.messages.must_include :username

      user.username = "test username"
      user.valid?.must_equal true
    end

    it "username must be unique" do
      one.username.must_equal "puppy"
      user.email = "email2"
      user.username = "puppy"
      user.valid?.must_equal false
      user.errors.messages.must_include :username
    end

    it "must have an email" do
      user.username = "username"
      user.email = "    "
      user.valid?.must_equal false
      user.errors.messages.must_include :email

      user.email = "email3"
      user.valid?.must_equal true
    end

    it "email must be unique" do
      one.email.must_equal "puppy@petsy.com"
      user.username = "name2"
      user.username = "puppy@petsy.com"
      user.valid?.must_equal false
      user.errors.messages.must_include :email
    end
  end

  describe 'custom methods' do
    it "builds user from auth_hash" do
      auth_hash = {
        info: { nickname: "test", email: "test@petsy.com" },
        uid: "124",
        provider: "github"
      }
      user = User.info_from_github(auth_hash)

      user.username.must_equal "test"
      user.email.must_equal "test@petsy.com"
      user.uid.must_equal 124
      user.provider.must_equal "github"
    end
  end
end
