class JobApplication < ApplicationRecord
  belongs_to :job_recruiter
  belongs_to :job
  has_one :job_applied, dependent: :destroy
  
end
