class Comment < ApplicationRecord
  # 関連付け
  belongs_to :user
  belongs_to :course
end
