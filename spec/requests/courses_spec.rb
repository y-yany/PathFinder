require 'rails_helper'

RSpec.describe "CoursesController", type: :request do
  let(:user) { create(:user) }

  before do
    post user_session_path, params: { user: { email: user.email, password: user.password } }
  end

  describe "GET #index" do
    it "リクエストが成功すること" do
      get courses_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET #new" do
    it "リクエストが成功すること" do
      get new_course_path
      expect(response).to have_http_status(200)
    end
  end

  describe "POST #create" do
    let(:positions) { [{ lat: 35.68291089208541, lng: 139.76012256480192 }, { lat: 35.681307393562676, lng: 139.75896196093043 }] }

    context "パラメータが妥当な場合" do
      it "リクエストが成功すること" do
        post courses_path, params: { course_marker_form: attributes_for(:course).merge(positions: positions.to_json) }
        expect(response).to have_http_status(302)  
      end

      it "コースが登録されること" do
        expect do
          post courses_path, params: { course_marker_form: attributes_for(:course).merge(positions: positions.to_json) }
        end.to change(Course, :count).by(1)
      end

      it "マーカーが2つ登録されること" do
        expect do
          post courses_path, params: { course_marker_form: attributes_for(:course).merge(positions: positions.to_json) }
        end.to change(Marker, :count).by(2)
      end

      it "リダイレクトされること" do
        post courses_path, params: { course_marker_form: attributes_for(:course).merge(positions: positions.to_json) }
        expect(response).to redirect_to Course.last
      end
    end

    context "パラメータが妥当でない場合" do
      it "リクエストが失敗すること" do
        post courses_path, params: { course_marker_form: attributes_for(:course, :invalid) }
        expect(response).to have_http_status(422)
      end

      it "コースが登録されないこと" do
        expect do
          post courses_path, params: { course_marker_form: attributes_for(:course, :invalid) }
        end.not_to change(Course, :count)
      end

      it "マーカーが登録されないこと" do
        expect do
          post courses_path, params: { course_marker_form: attributes_for(:course, :invalid) }
        end.not_to change(Marker, :count)
      end

      it "エラーメッセージが表示されること" do
        post courses_path, params: { course_marker_form: attributes_for(:course, :invalid) }
        expect(response.body).to include "コースを作成できませんでした"
      end
    end
  end

  describe "GET #show" do
    context "コースが存在する場合" do
      let(:positions) { [{ lat: 35.68291089208541, lng: 139.76012256480192 }, { lat: 35.681307393562676, lng: 139.75896196093043 }] }
      before do
        post courses_path, params: { course_marker_form: attributes_for(:course, :show).merge(positions: positions.to_json) }
      end

      it "リクエストが成功すること" do
        get course_path Course.last.id
        expect(response).to have_http_status(200)
      end

      it "コース名が表示されていること" do
        get course_path Course.last.id
        expect(response.body).to include "Show"
      end
    end

    context "コースが存在しない場合" do
      xit "エラーが発生すること" do
        expect { get course_path 1 }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe "DELETE #destroy" do
    let(:positions) { [{ lat: 35.68291089208541, lng: 139.76012256480192 }, { lat: 35.681307393562676, lng: 139.75896196093043 }] }
    before do
      post courses_path, params: { course_marker_form: attributes_for(:course).merge(positions: positions.to_json) }
    end
    
    it "リクエストが成功すること" do
      delete course_path Course.last
      expect(response).to have_http_status(303)
    end
    
    it "コースが削除されること" do
      expect do
        delete course_path Course.last
      end.to change(Course, :count).by(-1)
    end
    
    it "マーカーが2つ削除されること" do
      expect do
        delete course_path Course.last
      end.to change(Marker, :count).by(-2)
    end
    
    it "リダイレクトされること" do
      delete course_path Course.last
      expect(response).to redirect_to courses_path
    end
  end
  
  describe "GET #search" do
    it "リクエストが成功すること"
  end
end
