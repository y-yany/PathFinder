class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2]

  has_many :courses, dependent: :destroy

  validates :name, presence: true, length: { maximum: 20 }
  validates :uid, uniqueness: { scope: :provider }

  # ユーザー自身のオブジェクトか確認するメソッド
  def own?(object)
    id == object&.user_id
  end

  # 
  def self.from_omniauth(auth)
    user = User.where(uid: auth.uid, provider: auth.provider).first
  
    unless user
        user = User.create(
          name: auth.info.name,
          uid: auth.uid,
          provider: auth.provider,
          email: User.dummy_email(auth),
          password: Devise.friendly_token[0,20]
        )
    end
    user
  end

  private

  def self.dummy_email(auth)
    "#{auth.uid}-#{auth.provider}@example.com"
  end
end
