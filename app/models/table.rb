class Table < ApplicationRecord
  has_many :orders, dependent: :destroy
  
  validates :table_number, presence: true, uniqueness: true
  validates :status, inclusion: { in: %w[available occupied reserved] }
  
  before_create :generate_qr_code
  
  scope :available, -> { where(status: 'available') }
  scope :occupied, -> { where(status: 'occupied') }
  
  def display_name
    "Table #{table_number}"
  end
  
  private
  
  def generate_qr_code
    self.qr_code = "QR-TABLE-#{table_number}-#{SecureRandom.hex(4)}"
  end
end
