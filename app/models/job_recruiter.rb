class JobRecruiter < ApplicationRecord
  belongs_to :user
  has_many :job  
  validates :Comapany_name, :address, presence: true
  validates :phone_no, :Gst_no, presence: true, uniqueness: true 
  has_many :job_applications
end
