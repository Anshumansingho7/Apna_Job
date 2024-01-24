class JobApplication < ApplicationRecord
  belongs_to :job_recruiter
  belongs_to :job
  
end
