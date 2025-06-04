class LikesController < ApplicationController
  def create
    like = current_user.likes.build(course_id: params[:course_id])
    like.save
    redirect_to request.referer || courses_path
  end

  def destroy
    like = Like.find(params[:id])
    like.destroy!
    redirect_to request.referer || courses_path, status: :see_other
  end
end
