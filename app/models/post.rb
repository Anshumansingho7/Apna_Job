class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_one_attached :picture

  def total_comments
    comments.count
  end

  def total_likes
    likes.count
  end

  def picture_url
    if picture.attached?
      Rails.application.routes.url_helpers.rails_blob_path(self.picture, only_path: true)
    else
      nil
    end
  end

end
