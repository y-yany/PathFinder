class SearchCoursesForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :title, :string
  attribute :body, :string
  attribute :distance, :decimal
  attribute :location, :string
end
