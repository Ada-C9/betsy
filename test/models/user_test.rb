require "test_helper"

describe User do
  let(:user) { User.new(
    username: "Greg",
    provider: 'github',
    email: 'Greg@naver.com',
    uid: 901 ) }

    it "must be valid" do
      value(user).must_be :valid?
    end

    describe 'relations' do
      it 'has a list of products' do
        user = users(:anne)
        user.must_respond_to :products

        user.products.each do |product|
          product.must_be_kind_of Product
        end
      end
    end

    describe 'validations' do
      it 'requires a username' do
        user = User.new
        user.valid?.must_equal false
        user.errors.messages.must_include :username
      end

      it 'requires a unique username' do
        user = User.new(
          username: 'username',
          password: 'helloworld',
          uid: 123,
          provider: 'github')

          user.save!

          user2 = User.new(username: 'username')
          result = user2.save
          result.must_equal false
          user2.errors.messages.must_include :username
        end
      end

  #     describe 'calculate revenue' do
  #       it "figures out total revenue for user" do
  #         user = User.first
  #         user.products.wont_be_nil
  #         user.orders.wont_be_nil
  #
  #         expected_result = 0.0
  #         user.orders.each do |order|
  #           products = order.products.where(user_id: user.id)
  #           products.each do |product|
  #             orderitems = order.orderitems.where(product_id: product.id)
  #             orderitems.each do |orderitem|
  #               order.subtotal()
  #               expected_result += order.
  #             end
  #           end
  #         end
  #         expected_result.must_equal nil
  #         user.total_revenue.must_equal expected_result
  #       end
  #     end
  #   end
  # end
end
