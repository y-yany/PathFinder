class CoursesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show search]
  before_action :set_map_id, only: %i[new show]

  def index
    @q = SearchCoursesForm.new(search_params)
    @courses = @q.search.includes(:user).order(created_at: :desc).page(params[:page])
  end

  def new
    @course_marker_form = CourseMarkerForm.new
  end

  def create
    @course_marker_form = CourseMarkerForm.new(course_marker_params)
    course = @course_marker_form.save
    if course
      redirect_to course_path(id: course.id), success: "コースを作成しました"
    else
      flash.now[:error] = "コースを作成できませんでした"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @course = Course.find(params[:id])
    set_course_data(@course)
  end

  def destroy
    @course = current_user.courses.find(params[:id])
    @course.destroy!
    redirect_to courses_path, success: "コースを削除しました", status: :see_other
  end

  def search
    @title_match_courses = Course.where("title LIKE ?", "%#{params[:q]}%")
    @address_match_courses = Course.where("address LIKE ?", "%#{params[:q]}%")
    respond_to do |format|
      format.js
    end
  end

  private

  def course_marker_params
    params.require(:course_marker_form).permit(:title, :body, :distance, :address, :encoded_polyline, :positions, main_images: []).merge(user_id: current_user.id)
  end

  def set_map_id
    gon.google_map_id = Rails.application.credentials.google_maps_mapId
  end

  def set_course_data(course)
    gon.course_encoded_polyline = course.encoded_polyline
    gon.start_position = {
      lat: course.markers[0].location.latitude,
      lng: course.markers[0].location.longitude
    }
  end

  def search_params
    params[:q]&.permit(:course_query, :min_distance, :max_distance)
  end
end
