class Marker < ApplicationRecord
  belongs_to :course

  validates :location, presence: true
  validates :order, numericality: { greater_than_or_equal_to: 0 }
end
