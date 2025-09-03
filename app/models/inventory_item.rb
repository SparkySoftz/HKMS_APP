class InventoryItem < ApplicationRecord
  belongs_to :supplier
  
  validates :name, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :unit, presence: true
  validates :expiry_date, presence: true
  validates :created_by, presence: true
  
  scope :expiring_soon, -> { where(expiry_date: Date.current..3.days.from_now) }
  scope :expired, -> { where('expiry_date < ?', Date.current) }
  scope :available, -> { where('quantity > 0 AND expiry_date >= ?', Date.current) }
  
  def days_to_expiry
    (expiry_date - Date.current).to_i
  end
  
  def expiry_status
    days = days_to_expiry
    if days < 0
      'expired'
    elsif days <= 3
      'expiring_soon'
    else
      'fresh'
    end
  end
  
  def status_color
    case expiry_status
    when 'expired'
      'danger'
    when 'expiring_soon'
      'warning'
    else
      'success'
    end
  end
end
