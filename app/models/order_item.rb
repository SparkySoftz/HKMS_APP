class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :menu_item
  
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :unit_price, presence: true, numericality: { greater_than: 0 }
  validates :subtotal, presence: true, numericality: { greater_than_or_equal_to: 0 }
  
  before_save :calculate_subtotal
  after_save :update_order_total
  after_destroy :update_order_total
  
  private
  
  def calculate_subtotal
    self.subtotal = quantity * unit_price
  end
  
  def update_order_total
    order.calculate_total
  end
end
