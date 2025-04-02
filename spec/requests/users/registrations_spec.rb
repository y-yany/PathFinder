require 'rails_helper'

RSpec.describe "Users::RegistrationsController", type: :request do
  describe "GET #new" do
    it "リクエストが成功すること" do
      get new_user_registration_path
      expect(response).to have_http_status(200)
    end
  end

  describe "POST #create" do
    context "パラメータが妥当な場合" do
      it "リクエストが成功すること" do
        post user_registration_path, params: { user: attributes_for(:user) }
        expect(response).to have_http_status(303)
      end
      
      it "ユーザーが登録されること" do
        expect do
          post user_registration_path, params: { user: attributes_for(:user) }
        end.to change(User, :count).by(1)
      end
    end

    context "パラメータが妥当でない場合" do
      it "リクエストが失敗すること" do
        post user_registration_path, params: { user: attributes_for(:user, :invalid) }
        expect(response).to have_http_status(422)
      end
      
      it "エラーメッセージが表示されること" do
        post user_registration_path, params: { user: attributes_for(:user, :invalid) }
        expect(response.body).to include "Eメールを入力してください"
      end
      
      it "ユーザーが登録されないこと" do
        expect do
          post user_registration_path, params: { user: attributes_for(:user, :invalid) }
        end.not_to change(User, :count)
      end
    end
  end
end
