class User < ApplicationRecord
  has_secure_password
  
  # Validations
  validates :username, presence: true, uniqueness: true, length: { minimum: 3, maximum: 50 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :first_name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :last_name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :role, presence: true, inclusion: { in: %w[admin customer chef accountant store_keeper cashier] }
  validates :status, presence: true, inclusion: { in: %w[active inactive suspended] }
  validates :phone, format: { with: /\A[+]?[0-9\-\s()]+\z/, message: "Invalid phone format" }, allow_blank: true
  
  # Scopes
  scope :active, -> { where(status: 'active') }
  scope :by_role, ->(role) { where(role: role) }
  
  # Methods
  def full_name
    "#{first_name} #{last_name}"
  end
  
  def display_role
    role.humanize.titleize
  end
  
  def active?
    status == 'active'
  end
  
  def admin?
    role == 'admin'
  end
  
  # Default values
  after_initialize :set_defaults, if: :new_record?
  
  private
  
  def set_defaults
    self.role ||= 'customer'
    self.status ||= 'active'
  end
end
