class Api::V1::MypostsController < ApplicationController

  include NotFound

  def index 
    posts = Post.where(user_id: current_user.id)
    comments = Comment.where(post_id: posts.pluck(:id))
    likes = Like.where(post_id: posts.pluck(:id))
    render json: posts, include: ['comments', 'likes']
  end   
end
