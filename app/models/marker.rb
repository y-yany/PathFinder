# == Schema Information
#
# Table name: markers
#
#  id                   :bigint           not null, primary key
#  course_id            :bigint
#  location             :st_point         not null
#  order                :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_markers_on_course_id             (course_id)
#  index_markers_on_location_and_order    (location, order)
#

class Marker < ApplicationRecord
  belongs_to :course

  validates :location, presence: true
  validates :order, numericality: { greater_than_or_equal_to: 0 }
  validates :order, uniqueness: { scope: :course_id }
end
