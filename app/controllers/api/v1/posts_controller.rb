class Api::V1::PostsController < ApplicationController
  include NotFound

  before_action :authenticate_user!
  before_action :set_post, only: [:show, :destroy, :update]

  def index
    @posts = Post.all.includes(:comments, :likes)
    render json: @posts, methods: [:total_comments, :total_likes]
  end

  def show 
    comments = Comment.all
    likes = Like.all
    render json: @post, include: ['comments', 'likes']
  end

  def create 
    @post = current_user.posts.new(post_params)
    if @post.save
      render json: {
        data: @post.as_json.merge(url: @post.picture_urls)                
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
        render json: {
        data: @post.as_json.merge(url: @post.picture_urls)                
      },status: :ok
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
  end

  def post_params
    params.permit(:description, :image, pictures: [])
  end

end
