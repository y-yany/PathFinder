class CoursesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    @courses = Course.includes(:user)
  end

  def new
    @course_marker_form = CourseMarkerForm.new
    gon.google_map_id = Rails.application.credentials.google_maps_mapId
  end

  def create
    @course_marker_form = CourseMarkerForm.new(course_marker_params)
    course_id = @course_marker_form.save
    if course_id
      redirect_to course_path(id: course_id), success: "コースを作成しました"
    else
      @course_marker_form = CourseMarkerForm.new
      flash.now[:error] = "コースを作成できませんでした"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @course = Course.find(params[:id])
  end

  private

  def course_marker_params
    params.require(:course_marker_form).permit(:title, :body, :distance, :address, :encoded_polyline, :positions).merge(user_id: current_user.id)
  end
end
