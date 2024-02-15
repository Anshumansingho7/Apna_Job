class Api::V1::ApprovedJobsController < ApplicationController

  include NotificationCreater
  include JobStatusUpdate
  include RoleDefined
  include NotFound

  def update
    return unless job_recruiter_role
    job_application = JobApplication.find(params[:id])
    job_applied = JobApplied.find_by(job_application_id: job_application.id)
    return unless check_job(job_application, job_applied, "approved")
    job_seeker = JobSeeker.find(job_applied.job_seeker_id)
    user = User.find(job_seeker.user_id)
    NotificationMailer.job_approved(job_application.name, job_applied.company_name).deliver_now
    create_notification(user.id, "congratulation #{job_seeker.name} your job application has been approved")
  end
end
