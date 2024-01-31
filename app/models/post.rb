class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  def total_comments
    comments.count
  end

  def total_likes
    likes.count
  end
end
