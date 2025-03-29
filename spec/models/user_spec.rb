require 'rails_helper'

RSpec.describe User, type: :model do
  describe "バリデーションのチェック" do
    it "設定したバリデーションが機能していること" do
      user = build(:user)
      expect(user).to be_valid
    end
    
    it "ユーザー名がない場合無効であること" do
      user = build(:user, name: "")
      expect(user).to be_invalid
    end

    it "ユーザー名が21文字以上の場合無効であること" do
      user = build(:user, name: "a" * 21)
      expect(user).to be_invalid
    end

    it "Eメールがない場合無効であること" do
      user = build(:user, email: "")
      expect(user).to be_invalid
    end

    it "パスワードがない場合無効であること" do
      user = build(:user, password: "")
      expect(user).to be_invalid
    end

    it "パスワードとパスワード確認が一致しない場合無効であること" do
      user = build(:user, password: "password", password_confirmation: "diff_password")
      expect(user).to be_invalid
    end

    it "Eメールが一意でない場合無効であること" do
      user = create(:user)
      user_with_duplicated_email = build(:user, email: user.email)
      expect(user_with_duplicated_email).to be_invalid
    end

    it "uidとproviderの組み合わせが一意でない場合無効であること" do
      user = create(:user)
      user_with_duplicated_uid_and_provider = build(:user, uid: user.uid)
      expect(user_with_duplicated_uid_and_provider).to be_invalid
    end

    it "ユーザー名が20文字以下の場合有効であること" do
      user = build(:user, name: "a" * 20)
      expect(user).to be_valid
    end

    it "Eメールが一意である場合有効であること" do
      user = create(:user)
      user_with_another_email = build(:user, email: "another@example.com")
      expect(user_with_another_email).to be_valid
    end
  end
end
