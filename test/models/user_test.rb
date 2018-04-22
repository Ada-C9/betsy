require "test_helper"

describe User do
  let(:user) { User.new }
  let(:u) { users(:user_1) }

  describe "relations" do
    it "has a list of products" do
      u.products.each do |product|
        product.must_be_instance_of Product
        product.user.must_be_instance_of User
        product.user.must_equal u
      end
    end

    it "has many orderitems through products" do
      oi = u.order_items
      orderitems = []
      oi.each{|item|
        item.must_be_instance_of OrderItem
        orderitems << item
      }
      u.products.map{|p| p.order_items}.flatten.must_equal orderitems
    end

    it "returns an empty array if user has no product" do
      user.products.must_equal []
    end
  end

  describe "validations" do
    it "has validation for empty parameters" do
      user.valid?.must_equal false
    end

    it "has validation for username presence" do
      u.username = nil
      u.valid?.must_equal false
      u.errors.messages.must_include :username

      u.username = ""
      u.valid?.must_equal false
      u.errors.messages.must_include :username
    end

    it "has validation for username uniqueness" do
      u1 = User.new({ username: u.username, email: "aaa@example.com", uid: "11111111", provider: "github" })
      u1.valid?.must_equal false
      u1.errors.messages.must_include :username
    end

    it "has validation for email presence" do
      u.email = nil
      u.valid?.must_equal false
      u.errors.messages.must_include :email

      u.email = ""
      u.valid?.must_equal false
      u.errors.messages.must_include :email

    end

    it "has validation for email uniqueness" do
      u1 = User.new({ username: "test", email: u.email, uid: 11111111, provider: "github" })
      u1.valid?.must_equal false
      u1.errors.messages.must_include :email
    end

    it "has validation for email format" do
      u1 = User.new({ username: "test", email: "bad email", uid: 11111111, provider: "github" })
      u1.valid?.must_equal false
      u1.errors.messages.must_include :email

      u1 = User.new({ username: "test", email: "bad_email@with_no_dot", uid: "11111111", provider: "github" })
      u1.valid?.must_equal false
      u1.errors.messages.must_include :email
    end

    it "must be valid" do
      u.valid?.must_equal true
    end
  end

  describe "methods" do
    it "builds user from auth_hash" do
      auth_hash = {
        info: { nickname: "test", email: "test@example.com" },
        uid: "11111111",
        provider: "github"
      }
      user = User.build_from_github(auth_hash)

      user.username.must_equal "test"
      user.email.must_equal "test@example.com"
      user.uid.must_equal "11111111"
      user.provider.must_equal "github"
    end

    it "can create user" do
      u1 = User.new({ username: "Charles", email: "charles@example.com", uid: "11111111", provider: "github" })
      u1.save.must_equal true
    end

    it "computes number of orders" do
      u.num_orders.must_equal 1

      # user with no order yet
      u1 = User.create({ username: "test", email: "test@example.com", uid: "11111111", provider: "github" })
      u1.num_orders.must_equal 0
    end

    it "computes number of orders by status" do
      u.num_orders_by_status("pending").must_equal 1
      u.num_orders_by_status("paid").must_equal 0
    end

    it "computes total revenue" do
      u2 = users(:user_2)
      u2.total_revenue.must_equal 0.13
    end

    it "computes total revenue by status" do
      u.total_revenue_by_status("pending").must_equal 0.01
      u.total_revenue_by_status("complete").must_equal 0
    end
  end
end
