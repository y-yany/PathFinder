class Comment < ApplicationRecord
  # 関連付け
  belongs_to :user
  belongs_to :course

  # バリデーション
  validates :body, presence: true, length: { maximum: 1_000 }
  validates :user_id, uniqueness: { scope: :course_id }
end
