class Feedback < ApplicationRecord
  belongs_to :order
  
  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :comment, presence: true, length: { minimum: 10 }
  
  scope :recent, -> { order(created_at: :desc) }
  scope :by_rating, ->(rating) { where(rating: rating) }
  
  def rating_stars
    '★' * rating + '☆' * (5 - rating)
  end
end
