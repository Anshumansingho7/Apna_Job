class RejectedJobApplication < ApplicationRecord
  belongs_to :job_application
  belongs_to :job_applied
  has_one :approved_job_application, dependent: :destroy
  has_one :rejected_job_application, dependent: :destroy
end
