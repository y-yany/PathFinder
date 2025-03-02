class SearchCoursesForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :course_query, :string
  attribute :distance, :integer

  def search
    relation = Course.distinct

    course_query_words.each do |word|
      relation = relation.title_contain(word)
      relation = relation.body_contain(word)
      relation = relation.address_contain(word)
    end

    relation = relation.distance_within_limit(distance) if distance.present?

    relation
  end

  private

  def course_query_words
    course_query.present? ? course_query.split(nil) : []
  end
end
