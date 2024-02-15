class Api::V1::LikesController < ApplicationController

  include NotificationCreater
  include NotFound
  
  def index
    post_id = params[:post_id].to_i
    likes = Like.where(post_id: post_id)
    render json: likes
  end

  def likeindex
    likes = current_user.likes
    render json: likes
  end

  def create 
    post = Post.find(params[:post_id])
    like = Like.find_by(post_id: post.id, user_id: current_user.id)
    if like.present?
      destroy_like(post, like)       
    else
      create_like(post, like)
    end  
  end

  private

  def destroy_like(post, like)
    if like.destroy
      if current_user.id = post.user_id
        post
      else
        if current_user.role == "job_seeker"
          @job_seeker = current_user.job_seeker
          Notification.where(user_id: post.user_id, discription: "#{@job_seeker.name} has liked on your post #{post.id}").destroy_all
        else
          @job_recruiter = current_user.job_recruiter 
          Notification.where(user_id: post.user_id, discription: "#{@job_recruiter.name} has liked on your post #{post.id}").destroy_all
        end
      end
      render json: {
        message: "post unliked succesfully"
      }               
    else 
      render json: {
        data: like.errors.full_messages,
      }
    end
  end

  def create_like(post, like)
    like = Like.new(
      post_id: post.id,
      user_id: current_user.id,
    )
    if like.save
      unless current_user.id = post.user_id
        if current_user.role == "job_seeker"
          @job_seeker = current_user.job_seeker
          create_notification(post.user_id, "#{@job_seeker.name} has liked on your post #{post.id}") 
        else
          @job_recruiter = current_user.job_recruiter
          create_notification(post.user_id, "#{@job_recruiter.name} has liked on your post #{post.id}") 
        end
      end
      render json: {
        message: "post like succesfully"
      }
    else 
      render json: {
        data: like.errors.full_messages,
        status: 'failed'
      },status: :unprocessable_entity
    end
  end
end
