class MenuItem < ApplicationRecord
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :menu_date, presence: true
  validates :status, inclusion: { in: %w[draft active inactive] }
  validates :created_by, presence: true
  
  scope :active, -> { where(status: 'active') }
  scope :for_date, ->(date) { where(menu_date: date) }
  scope :current_menu, -> { where(menu_date: Date.current, status: 'active') }
  
  def ingredients_list
    ingredients.split(',').map(&:strip) if ingredients.present?
  end
end
