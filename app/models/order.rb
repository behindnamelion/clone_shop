class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :packs, through: :order_items
  has_one :payment, dependent: :nullify
  
  enum status: [:before_payment, :processed, :completed, :failed, :cancelled]
  
  def product_price
    result = 0
  
    self.order_items.each do |order_item|
      result += order_item.quantity * order_item.pack.price
    end
  
    return result
  end
  
  def shipping_fee
    if self.product_price > 15000
      result = 0
    else
      result = 2500
    end
  
    return result
  end
  
  def total_price
    result = self.product_price + self.shipping_fee
    
    return result
  end
end
