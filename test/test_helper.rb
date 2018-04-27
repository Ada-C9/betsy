require 'simplecov'
# require 'simplecov-console'
# SimpleCov.formatter = SimpleCov.formatter = SimpleCov::Formatter::Console
# SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
#   SimpleCov::Formatter::HTMLFormatter,
#   SimpleCov::Formatter::Console,
# ])

SimpleCov.start 'rails' do
  add_filter '/app/jobs/application_job.rb'
  add_filter '/app/mailers/application_mailer.rb'
  add_filter '/app/channels/application_cable/channel.rb'
  add_filter '/app/channels/application_cable/connection.rb'
  add_filter '/app/helpers/'
end

ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)

require "rails/test_help"
require "minitest/rails"
require "minitest/reporters"  # for Colorized output

#  For colorful output!
Minitest::Reporters.use!(
  Minitest::Reporters::SpecReporter.new,
  ENV,
  Minitest.backtrace_filter
)


# To add Capybara feature tests add `gem "minitest-rails-capybara"`
# to the test group in the Gemfile and uncomment the following:
# require "minitest/rails/capybara"

# Uncomment for awesome colorful output
# require "minitest/pride"

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  # Add more helper methods to be used by all tests here...
  def setup
    OmniAuth.config.test_mode = true
  end

  def mock_auth_hash(user)
    return {
      provider: user.provider,
      uid: user.uid,
      info: {
        email: user.email,
        name: user.name
      }
    }
  end

  def login(user)
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))
    get auth_callback_path(:github)
    must_redirect_to root_path
  end

  def new_buyer(order)
    payment_info = {
      email: "test@test.com",
      mailing_address: "123 Street",
      buyer_name: "Buyer Person",
      card_number: "1234567890",
      expiration: "01/01",
      cvv: "1234",
      zipcode: "12345",
      order_id: order.id
    }
    post checkout_path(order.id), params: { buyerdetail: payment_info }
    must_redirect_to order_path(order)
  end


  def retire_product(product_id)
    product = Product.find(product_id)

    product.retire

    result = Product.find(product_id)

    result.retired.must_be true
  end

end
