class StorekeeperTransaction < ApplicationRecord
  belongs_to :supplier
  validates :transaction_id, presence: true, uniqueness: true
  validates :date, presence: true
  validates :time, presence: true
  validates :item, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }
end