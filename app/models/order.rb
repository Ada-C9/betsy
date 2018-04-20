class Order < ApplicationRecord
  has_many :order_items

  def check_atleast_one_order_item
    if self.order_items.count < 1
      errors.add(:order, "need atleast one order item")
    end
  end
end
