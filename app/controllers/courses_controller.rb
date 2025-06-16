class CoursesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show search]

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
      redirect_to course_path(id: course.id), success: t('defaults.flash_message.created', item: Course.model_name.human)
    else
      flash.now[:error] = t('defaults.flash_message.not_created', item: Course.model_name.human)
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @course = Course.find(params[:id])
    set_course_data(@course)
    @comments = @course.comments.includes(:user).order(created_at: :desc)
  end

  def destroy
    @course = current_user.courses.find(params[:id])
    @course.destroy!
    redirect_to courses_path, success: t('defaults.flash_message.deleted', item: Course.model_name.human), status: :see_other
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
