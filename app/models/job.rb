class Job < ApplicationRecord
  belongs_to :job_recruiter
  validates :field, presence: true
end
