class Api::V1::CommentsController < ApplicationController

  include NotificationCreater
  include RoleDefined
  include NotFound
  before_action :authenticate_user!
  before_action :set_post
  before_action :set_comment, only: [:show, :destroy]

  def index
    post_id = params[:post_id].to_i
    comments = Comment.where(post_id: post_id)
    render json: comments
  end

  def show
    if @comment.post_id == @post.id
      render json: @comment
    else 
      render json: "this comment doesnot belong to this post"
    end
  end

  def create 
    comment = @post.comments.new(comment_params.merge(user: current_user))
    if comment.save
      unless current_user.id = comment.user_id
        if current_user.role == "job_seeker"
          @job_seeker = current_user.job_seeker
          create_notification(@post.user_id, "#{@job_seeker.name} has commented on your post")
        else
          @job_recruiter = current_user.job_recruiter 
          create_notification(@post.user_id, "#{@job_recruiter.name} has commented on your post")
        end
      end
      render json: comment, status: :ok
    else
      render json: {
        data: comment.errors.full_messages,
        status: 'failed'
      },status: :unprocessable_entity
    end
  end

  def destroy
    if @comment.user_id == current_user.id
      if @comment.destroy
        render json: {
          message:  "comment destroy successfully"
        }
      else 
        render json: {
            data: @comment.errors.full_messages,
        }, status: :unprocessable_entity
      end
    else
      render json: {
          message: "you cannot delete this comment"
      }
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end
  
  def comment_params
    params.require(:comments).permit(:description)
  end
end
