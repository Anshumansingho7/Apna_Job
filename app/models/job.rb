class Job < ApplicationRecord
  belongs_to :job_recruiter
  validates :field, presence: true
  has_many :job_applications
  has_many :job_applied
end
