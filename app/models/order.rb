class Order < ApplicationRecord
  belongs_to :table, optional: true
  has_many :order_items, dependent: :destroy
  has_many :menu_items, through: :order_items
  has_one :feedback, dependent: :destroy
  
  accepts_nested_attributes_for :order_items, allow_destroy: true
  
  validates :customer_name, presence: true
  validates :status, inclusion: { in: %w[pending cooking ready completed cancelled draft] }
  validates :total_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  
  scope :pending, -> { where(status: 'pending') }
  scope :cooking, -> { where(status: 'cooking') }
  scope :ready, -> { where(status: 'ready') }
  scope :completed, -> { where(status: 'completed') }
  scope :active, -> { where(status: %w[pending cooking ready]) }
  
  before_create :set_order_date
  after_create :occupy_table
  after_update :update_table_status
  
  def order_number
    "ORD-#{id.to_s.rjust(6, '0')}"
  end
  
  def calculate_total
    self.total_amount = order_items.sum(:subtotal)
    save
  end
  
  def status_color
    case status
    when 'pending'
      'warning'
    when 'cooking'
      'info'
    when 'ready'
      'success'
    when 'completed'
      'primary'
    when 'cancelled'
      'danger'
    else
      'secondary'
    end
  end
  
  private
  
  def set_order_date
    self.order_date = Time.current
  end
  
  def occupy_table
    table.update(status: 'occupied') if table.present?
  end
  
  def update_table_status
    if status == 'completed' && table.present?
      table.update(status: 'available')
    end
  end
end
