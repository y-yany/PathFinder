class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable,
    :omniauthable, omniauth_providers: %i[google_oauth2]

  has_many :courses, dependent: :destroy

  validates :name, presence: true, length: { maximum: 20 }
  validates :uid, uniqueness: { scope: :provider }

  def own?(object)
    id == object&.user_id
  end
end
