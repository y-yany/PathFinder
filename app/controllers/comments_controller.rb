class CommentsController < ApplicationController
  def create
    comment = current_user.comments.build(comment_params)
    comment.save
    redirect_to course_path(comment.course)
  end

  def destroy
    comment = Comment.find(params[:id])
    comment.destroy
    redirect_to course_path(comment.course), status: :see_other
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(course_id: params[:course_id])
  end
end
