class LikesController < ApplicationController
  def create
    @course = Course.find(params[:course_id])
    current_user.like(@course)
  end

  def destroy
    @course = Like.find(params[:id]).course
    current_user.unlike(@course)
  end
end
