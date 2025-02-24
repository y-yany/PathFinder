class Course < ApplicationRecord
  belongs_to :user
  has_many :markers, dependent: :destroy
  has_many_attached :main_images do |attachable|
    attachable.variant :thumb, resize_to_fill: [300, 200]
  end

  validates :title, presence: true
  validates :body, length: { maximum: 1_000 }
  validates :distance, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 999.99 }
  validates :address, length: { maximum: 255 }
  validates :encoded_polyline, presence: true, length: { maximum: 255 }
  validates :main_images, attachment: { purge: true, content_type: %r{\Aimage/(png|jpeg)\Z}, maximum: 5_242_880 }
end
