class Supplier < ApplicationRecord
  has_many :storekeeper_transactions, dependent: :restrict_with_error
  validates :supplier_code, presence: true, uniqueness: true
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  
  def name_with_code
    "#{name} (#{supplier_code})"
  end
end