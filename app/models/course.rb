# == Schema Information
#
# Table name: courses
#
#  id                   :bigint           not null, primary key
#  user_id              :bigint
#  title                :string(255)      not null
#  body                 :text             default("")
#  distance             :decimal
#  address              :string(255)      default("")
#  encoded_polyline     :text             not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_courses_on_user_id     (user_id)
#

class Course < ApplicationRecord
  belongs_to :user
  has_many :markers, dependent: :destroy
  has_many_attached :main_images do |attachable|
    attachable.variant :thumb, resize_to_fill: [300, 200]
    attachable.variant :twitter_card, resize_to_limit: [800, 800]
  end

  validates :title, presence: true
  validates :body, length: { maximum: 1_000 }
  validates :distance, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 999.99 }
  validates :address, length: { maximum: 255 }
  validates :encoded_polyline, presence: true, length: { maximum: 65_535 }
  validates :main_images, attachment: { purge: true, content_type: %r{\Aimage/(png|jpeg)\Z}, maximum: 5_242_880 }

  scope :title_body_address_contain, ->(word) { where("title LIKE ? OR body LIKE ? OR address LIKE ?", "%#{word}%", "%#{word}%", "%#{word}%") }
  scope :distance_greater_than, ->(distance) { where(distance: distance..) }
  scope :distance_less_than, ->(distance) { where(distance: ..distance) }
end
