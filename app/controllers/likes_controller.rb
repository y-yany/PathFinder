class LikesController < ApplicationController
  def create
    @course = Course.find(params[:course_id])
    current_user.like(@course)
    redirect_to request.referer || courses_path
  end

  def destroy
    @course = Like.find(params[:id]).course
    current_user.unlike(@course)
    redirect_to request.referer || courses_path, status: :see_other
  end
end
