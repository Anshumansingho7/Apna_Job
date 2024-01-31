class Api::V1::PostsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_post, only: [:show, :destroy]

    def index
        #@posts = Post.all
        #comments = Comment.all.count
        #likes = Like.all.count
        #render json: @posts, include: ['comments', 'likes']
        @posts = Post.all.includes(:comments, :likes)
        render json: @posts, methods: [:total_comments, :total_likes]
    end

    def show 
        render json: @post
        comments = Comment.all
        likes = Like.all
        render json: @posts, include: ['comments', 'likes']
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
        post = Post.find(params[:id])
        #debugger
        like = Like.find_by(post_id: post.id, user_id: current_user.id)
        if like.present?
            like.destroy
            #post.update(like: post.like - 1)
            render json: {
                message: "Post unliked succesfully"
            }
        else
            like = Like.new(
                post_id: post.id,
                user_id: current_user.id
            )
            if like.save
                #post.update(like: post.like + 1)
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
        params.require(:posts).permit(:description, :image, :like)
    end

    #def authenticate_user!
    #    jwt_payload = JWT.decode(request.headers["authorization"].split(' ')[1], Rails.application.credentials.fetch(:secret_key_base)).first
    #    current_user = User.find(jwt_payload['sub'])
    #end
end
