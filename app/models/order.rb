class Order < ApplicationRecord

  STATUS = %w(pending paid complete cancelled)

  has_many :order_items, dependent: :destroy


with_options if: :checking_out? do |order|
 order.validates :status, presence: true, inclusion: { in: STATUS }
 order.validates :email, presence: true
 order.validates :mail_adr, presence: true
 order.validates :cc_name, presence: true
 order.validates :cc_num, presence: true, numericality: {only_integer: true}, length: {is: 16}
 order.validates :cc_exp, presence: true
 order.validates :cc_cvv, presence: true, numericality: {only_integer: true}, length: {is: 3}
 order.validates :bill_zip, presence: true, numericality: {only_integer: true}
end

 def checking_out?
   self.status != "pending"
 end


  def total_sum
    total = 0
    self.order_items.each do |item|
      sub_total = item.sub_total
      total += sub_total
    end
    return total
  end

  def reduce_inventory
    self.order_items.each do |item|
      item.product.stock_reduction(item.quantity)
    end

  end

end
