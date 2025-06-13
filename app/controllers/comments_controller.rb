class CommentsController < ApplicationController
  def new
    @comment = Comment.new
    @course = Course.find(params[:course_id])
  end

  def create
    @comment = current_user.comments.build(comment_params)
    @comment.save
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(course_id: params[:course_id])
  end
end
