class SearchCoursesForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :course_query, :string
  attribute :min_distance, :integer
  attribute :max_distance, :integer

  validates_with DistanceValidator

  def search    
    relation = Course.distinct

    return relation unless valid?

    course_query_words.each do |word|
      relation = relation.title_body_address_contain(word)
    end

    relation = relation.distance_greater_than(min_distance) if min_distance.present?

    relation = relation.distance_less_than(max_distance) if max_distance.present?

    relation
  end

  private

  def course_query_words
    course_query.present? ? course_query.split(nil) : []
  end
end
