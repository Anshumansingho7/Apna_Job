class JobRecruiter < ApplicationRecord
  belongs_to :user
  has_many :job, dependent: :destroy 
  validates :name, :address, presence: true
  validates :phone_no, :Gst_no, presence: true, uniqueness: true 
  has_many :job_applications, dependent: :destroy


end
