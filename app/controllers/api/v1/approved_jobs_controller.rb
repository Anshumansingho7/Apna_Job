class Api::V1::ApprovedJobsController < ApplicationController

  def update 
    job_application = JobApplication.find(params[:id])
    job_applied = JobApplied.find_by(job_application_id: job_application.id)
    
    if job_application.job_recruiter_id == current_user.job_recruiter.id
      @rname = job_applied.company_name
      @sname = job_application.name
      if job_application.update(status: "Approved") && job_applied.update(status: "Approved")
        NotificationMailer.job_approved(@sname, @rname).deliver_now
        render json: {
          message: "Job approved succesfully"
        }
      else 
        render json: {
          message: "Failed to approve job"
        }
      end
    else
      render json: {
        message: "This job application does not belong to you"
      }
    end
  end

end