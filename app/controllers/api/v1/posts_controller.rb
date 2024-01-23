class Api::V1::PostsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_post, only: [:show, :update, :destroy]

    def index
        @posts = Post.all
        render json: @posts
    end

    def show 
        render json: @post
    end

    def create 
        @post = current_user.posts.new(post_params)
        if @post.save
            render json: @post, status: :ok
        else
            render json: {
                data: @post.errors.full_messages,
                status: 'failed'
            },status: :unprocessable_entity
        end
    end


    def update
        if @post.update(post_params)
            render json: @post, status: :ok
        else
            render json: {
                data: @post.errors.full_messages,
                status: 'failed'
            },status: :unprocessable_entity
        end
    end

    def destroy
        if @post.destroy
            render json: {
              message:  "post destroy successfully"
            }
        else 
            render json: {
                data: @post.errors.full_messages,
            }, status: :unprocessable_entity
        end
    end
    private

    def set_post
        @post = Post.find(params[:id])
    rescue ActiveRecord::RecordNotFound => error
        render json: {
            data: error.message, 
            status: :unauthorized
        }
    end

    def post_params
        params.require(:posts).permit(:description, :image)
    end

    #def authenticate_user!
    #    jwt_payload = JWT.decode(request.headers["authorization"].split(' ')[1], Rails.application.credentials.fetch(:secret_key_base)).first
    #    current_user = User.find(jwt_payload['sub'])
    #end
end
