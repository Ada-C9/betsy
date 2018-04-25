require "test_helper"

describe Review do
  let(:review) { reviews(:one) }

  describe "#valid?" do

    it "should return false without a rating" do
      review.rating = nil
      review.valid?.must_equal false
    end

    it "should return false if rating is not between 1 and 5" do
      review.rating = 6
      review.valid?.must_equal false
    end

    it "should return false if rating is a letter" do
      review.rating = "b"
      review.valid?.must_equal false
    end

    it "should no more than 500 character" do

      review.text_review = "Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibusAenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus"
      review.valid?.must_equal false

    end
  end

  describe "#product" do
    it "should return the associated product" do
      review.product.must_equal products(:dragon)
    end

    it "should return the correct number of reviews" do
      products(:dragon).reviews.count.must_equal 2
    end
  end


end
