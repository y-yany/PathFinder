class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable

  has_many :courses, dependent: :destroy

  validates :name, presence: true, length: { maximum: 20 }

  def own?(object)
    id == object&.user_id
  end
end
