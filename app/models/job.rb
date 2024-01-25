class Job < ApplicationRecord
  belongs_to :job_recruiter
  validates :field, presence: true
  has_many :job_applications, dependent: :destroy
  has_many :job_applied, dependent: :destroy
  
end
