class ApprovedJobApplication < ApplicationRecord
  belongs_to :job_application
  belongs_to :job_applied
end
