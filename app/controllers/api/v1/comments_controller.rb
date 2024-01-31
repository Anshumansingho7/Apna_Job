class Api::V1::CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post
  before_action :set_comment, only: [:show, :update, :destroy]

  def index
    post_id = params[:post_id]
    comments = Comment.where(post_id: post_id)
    render json: comments
  end

  def likeindex
    post_id = params[:post_id]
    likes = Like.where(post_id: post_id)
    render json: likes
  end

  def show 
    render json: @comment
  end

    def create 
        comment = @post.comments.new(comment_params.merge(user: current_user))
        if comment.save
            render json: comment, status: :ok
        else
            render json: {
                data: comment.errors.full_messages,
                status: 'failed'
            },status: :unprocessable_entity
        end
    end


    def update
        if @comment.update(comment_params)
            render json: @comment, status: :ok
        else
            render json: {
                data: @comment.errors.full_messages,
                status: 'failed'
            },status: :unprocessable_entity
        end
    end

    def destroy
        if @comment.destroy
            render json: {
              message:  "comment destroy successfully"
            }
        else 
            render json: {
                data: @comment.errors.full_messages,
            }, status: :unprocessable_entity
        end
    end
    private

    def set_post
        @post = Post.find(params[:post_id])
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
