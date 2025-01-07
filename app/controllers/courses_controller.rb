class CoursesController < ApplicationController
  def new
    @course_marker_form = CourseMarkerForm.new
    gon.google_map_id = Rails.application.credentials.google_maps_mapId
  end

  def create
    @course_marker_form = CourseMarkerForm.new(course_marker_params)
    if @course_marker_form.save
      redirect_to root_path, success: "コースを作成しました"
    else
      @course_marker_form = CourseMarkerForm.new
      flash.now[:error] = "コースを作成できませんでした"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def course_marker_params
    params.require(:course_marker_form).permit(:title, :body, :distance, :address, :encoded_polyline, :positions).merge(user_id: current_user.id)
  end
end
