require 'rails_helper'

RSpec.describe "Users::SessionsController", type: :request do
  describe "GET #new" do
    it "リクエストが成功すること" do
      get new_user_session_path
      expect(response).to have_http_status(200)
    end
  end
  
  describe "POST #create" do
    context "パラメータが妥当な場合" do
      let(:user) { create(:user) }

      it "リクエストが成功すること" do
        post user_session_path, params: { user: { email: user.email, password: user.password } }
        expect(response).to have_http_status(303)
      end

      it "リダイレクトすること" do
        post user_session_path, params: { user: { email: user.email, password: user.password } }
        expect(response).to redirect_to courses_path
      end
    end

    context "パラメータが不正な場合" do
      let(:user) { build(:user, email: "") }

      it "リクエストが失敗すること" do
        post user_session_path, params: { user: { email: user.email, password: user.password } }
        expect(response).to have_http_status(422) 
      end
      
      it "エラーメッセージが表示されること" do
        post user_session_path, params: { user: { email: user.email, password: user.password } }
        expect(response.body).to include "Eメールまたはパスワードが違います。" 
      end
    end
  end
  
  describe "DELETE #destroy" do
    let(:user) { create(:user) }
  
    it "リクエストが成功すること" do
      post user_session_path, params: { user: { email: user.email, password: user.password } }
      delete destroy_user_session_path
      expect(response).to have_http_status(303)
    end
    
    it "リダイレクトされること" do
      post user_session_path, params: { user: { email: user.email, password: user.password } }
      delete destroy_user_session_path
      expect(response).to redirect_to courses_path
    end
  end
end
