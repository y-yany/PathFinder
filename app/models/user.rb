# == Schema Information
#
# Table name: users
#
#  id                   :bigint           not null, primary key
#  name                 :string(255)      not null
#  email                :string(255)      not null, default("")
#  encrypted_password   :string(255)      not null, default("")
#  provider             :string(255)
#  uid                  :string(255)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_users_on_email                   (email)
#  index_users_on_uid_and_provider        (uid, provider)

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2]

  # 関連付け
  has_many :courses, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_courses, through: :likes, source: :course
  has_many :comments, dependent: :destroy
  has_one_attached :avatar

  # バリデーション
  validates :name, presence: true, length: { maximum: 20 }
  validates :uid, uniqueness: { scope: :provider }
  validates :avatar, attachment: { purge: true, content_type: %r{\Aimage/(jpg|png|jpeg)\Z}, maximum: 5_242_880 }
  validates :profile, length: { maximum: 1_000 }

  # ユーザー自身のオブジェクトか確認するメソッド
  def own?(object)
    id == object&.user_id
  end

  # Google認証に関するメソッド
  def self.from_omniauth(auth)
    user = User.where(uid: auth.uid, provider: auth.provider).first

    user ||= User.create(
      name: auth.info.name,
      uid: auth.uid,
      provider: auth.provider,
      email: User.dummy_email(auth),
      password: Devise.friendly_token[0, 20]
    )
    user
  end

  def self.dummy_email(auth)
    "#{auth.uid}-#{auth.provider}@example.com"
  end

  # いいね機能に関するメソッド
  def like(course)
    liked_courses << course
  end

  def unlike(course)
    liked_courses.destroy(course)
  end
end
