class Api::V1::PostsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_post, only: [:show, :destroy, :update]

    def index
        #@posts = Post.all
        #comments = Comment.all.count
        #likes = Like.all.count
        #render json: @posts, include: ['comments', 'likes']
        #debugger
        @posts = Post.all.includes(:comments, :likes)
        render json: @posts, methods: [:total_comments, :total_likes]
    end

    def show 
        post = Post.find(params[:id])
        #render json: post
        comments = Comment.all
        likes = Like.all
        render json: post, include: ['comments', 'likes']
    rescue ActiveRecord::RecordNotFound => error
        render json: {
            data: error.message, 
            status: :unauthorized
        }
    end


    def crete_image 
        post = Post.find(params[:id])
        if post.user_id == current_user.id
            if post.update(post_params)
                render json: post.picture_url, status: :ok
            else
                render json: {
                data: post.errors.full_messages,
                status: 'failed'
                },status: :unprocessable_entity
            end
        else
            render json: {
                message: "this post doesnot belong to you"
            }  
        end
    end

    def create 
        @post = current_user.posts.new(post_params)
        if @post.save
            render json: {
                data: @post.as_json.merge(url: @post.picture_url)
                
            },status: :ok
        else
            render json: {
                data: @post.errors.full_messages,
                status: 'failed'
            },status: :unprocessable_entity
        end
    end


    def update
        if @post.user_id == current_user.id
            if @post.update(post_params)
                render json: @post, status: :ok
            else
                render json: {
                    data: @post.errors.full_messages,
                    status: 'failed'
                },status: :unprocessable_entity
            end
        else
            render json: {
                message: "this post doesnot belong to you"
            }  
        end     
    end

    def destroy
        if @post.user_id == current_user.id
            if @post.destroy
                render json: {
                  message:  "post destroy successfully"
                }
            else 
                render json: {
                    data: @post.errors.full_messages,
                }, status: :unprocessable_entity
            end
        else
            render json: {
                message: "this post doesnot belong to you"
            }  
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
        params.permit(:description, :image, :picture)
    end



    #def authenticate_user!
    #    jwt_payload = JWT.decode(request.headers["authorization"].split(' ')[1], Rails.application.credentials.fetch(:secret_key_base)).first
    #    current_user = User.find(jwt_payload['sub'])
    #end
end
