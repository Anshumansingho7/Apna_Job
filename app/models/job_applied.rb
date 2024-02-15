class JobApplied < ApplicationRecord
  belongs_to :job_seeker
  belongs_to :job
  belongs_to :job_application
  
end
