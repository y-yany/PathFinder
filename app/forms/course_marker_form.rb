class CourseMarkerForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations

  # 属性
  attribute :title, :string
  attribute :body, :string
  attribute :distance, :decimal
  attribute :address, :string
  attribute :encoded_polyline, :string
  attribute :main_images, :array
  attribute :user_id, :integer
  attribute :positions, :array, default: []

  # バリデーション
  validates :user_id, presence: true

  def save
    course = Course.new(title: title, body: body, distance: distance, address: address, encoded_polyline: encoded_polyline, main_images: main_images, user_id: user_id)
    if course.save
      positions.each_with_index do |position, index|
        location = "POINT(#{position['lng']} #{position['lat']})"
        Marker.create(location: location, order: index, course_id: course.id)
      end
      course.id
    else
      false
    end
  end
end
