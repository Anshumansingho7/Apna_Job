class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many_attached :pictures

  def total_comments
    comments.count
  end

  def total_likes
    likes.count
  end

  def picture_urls
    if pictures.attached?
      self.pictures.map do |blob|
        Rails.application.routes.url_helpers.rails_blob_path(blob, only_path: true)
      end
    else
      []
    end
  end

  validate :validate_picture_type

  private

  def validate_picture_type
    if pictures.attached? && pictures.any? { |blob| blob.content_type.in?(%w(application/pdf)) }
      errors.add(:pictures, 'PDF files are not allowed')
    end
  end

end
