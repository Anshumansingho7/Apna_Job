class Api::V1::CommentsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_post
    before_action :set_comment, only: [:show, :destroy]

    def index
        post_id = params[:post_id].to_i
        comments = Comment.where(post_id: post_id)
        render json: comments
    end

    def show 
        render json: @comment
    end

    def create 
        comment = @post.comments.new(comment_params.merge(user: current_user))
        if comment.save
            if current_user.id = comment.user_id
                post
            else
                if current_user.role == "job_seeker"
                    @job_seeker = current_user.job_seeker
                    notification = Notification.new(
                        user_id: @post.user_id,
                        discription: "#{@job_seeker.name} has commented on your post"
                    )
                else
                    @job_recruiter = current_user.job_recruiter 
                    notification = Notification.new(
                        user_id: @post.user_id,
                        discription: "#{@job_recruiter.name} has commented on your post"
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
            render json: comment, status: :ok
        else
            render json: {
                data: comment.errors.full_messages,
                status: 'failed'
            },status: :unprocessable_entity
        end
    rescue ActiveRecord::RecordNotFound => error
        render json: {
            data: error.message, 
            status: :unauthorized
        }
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
    rescue ActiveRecord::RecordNotFound => error
        render json: {
            data: error.message, 
            status: :unauthorized
        }
    end

    def set_comment
        @comment = Comment.find(params[:id])
    rescue ActiveRecord::RecordNotFound => error
        render json: {
            data: error.message, 
            status: :unauthorized
        }
    end

    def comment_params
        params.require(:comments).permit(:description)
    end

    #def authenticate_user!
    #    jwt_payload = JWT.decode(request.headers["authorization"].split(' ')[1], Rails.application.credentials.fetch(:secret_key_base)).first
    #    current_user = User.find(jwt_payload['sub'])
    #end
end
