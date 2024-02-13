class Api::V1::ApprovedJobsController < ApplicationController
  def update
    job_application = JobApplication.find(params[:id])
    job_applied = JobApplied.find_by(job_application_id: job_application.id)

    if job_application.job_recruiter_id == current_user.job_recruiter.id
      @rname = job_applied.company_name
      @sname = job_application.name

      if job_application.update(status: "Approved") && job_applied.update(status: "Approved")
        NotificationMailer.job_approved(@sname, @rname).deliver_now
        render json: { message: "Job approved successfully" },status: 200
        job_seeker = JobSeeker.where(id: job_applied.job_seeker_id)
        user = User.where(id: job_seeker.user_id)
        notification = Notification.new(
          user_id: user.id,
          discription: "congratulation #{job_seeker.name} your job application has been approved"
          )
        if notification.save
        else 
          render json: {
            data: notification.errors.full_messages,
            status: 'failed'
          },status: :unprocessable_entity
        end
      else
        render json: { message: "Failed to approve job" },status: 500
      end
    else
      render json: { message: "This job application does not belong to you" },status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound => error
    render json: {
        data: error.message, 
        status: :unauthorized
    },status: 404
  end
end
