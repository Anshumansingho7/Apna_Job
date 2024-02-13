class Api::V1::LikesController < ApplicationController

    def index
        post_id = params[:post_id].to_i
        likes = Like.where(post_id: post_id)
        render json: likes
    rescue ActiveRecord::RecordNotFound => error
        render json: {
            data: error.message, 
            status: :unauthorized
        }
    end

    def likeindex
        likes = current_user.likes
        render json: likes
    end

    def create 
        post = Post.find(params[:post_id])
        #debugger
        like = Like.find_by(post_id: post.id, user_id: current_user.id)
        if like.present?
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
        else
            like = Like.new(
                post_id: post.id,
                user_id: current_user.id,
            )
            if like.save
                if current_user.id = post.user_id
                    post
                else
                    if current_user.role == "job_seeker"
                        @job_seeker = current_user.job_seeker
                        notification = Notification.new(
                            user_id: post.user_id,
                            discription: "#{@job_seeker.name} has liked on your post #{post.id}"
                        )
                    else
                        @job_recruiter = current_user.job_recruiter 
                        notification = Notification.new(
                            user_id: post.user_id,
                            discription: "#{@job_recruiter.name} has liked on your post #{post.id}"
                        )
                    end
                    if notification.save
                    else 
                        render json: {
                            data: notification.errors.full_messages,
                            status: 'failed'
                        },status: :unprocessable_entity
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
    rescue ActiveRecord::RecordNotFound => error
        render json: {
            data: error.message, 
            status: :unauthorized
        }
    end
end
