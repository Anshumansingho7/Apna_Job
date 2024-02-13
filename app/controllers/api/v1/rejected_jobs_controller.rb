class Api::V1::RejectedJobsController < ApplicationController

    def update 
        job_application = JobApplication.find(params[:id])
        job_applied = JobApplied.find_by(job_application_id: job_application.id)
        if job_application.job_recruiter_id == current_user.job_recruiter.id
            @rname = job_applied.company_name
            @sname = job_application.name
            if job_application.update(status: "Rejected") && job_applied.update(status: "Rejected")
                NotificationMailer.job_rejected(@sname, @rname).deliver_now
                render json: {
                   message: "Job Rejected succesfully"
                }
                job_seeker = JobSeeker.where(id: job_applied.job_seeker_id)
                user = User.where(id: job_seeker.user_id)
                notification = Notification.new(
                    user_id: user.id,
                    discription: "Sorry to inform you #{job_seeker.name} your job application has been rejected"
                    )
                if notification.save
                else 
                  render json: {
                        data: notification.errors.full_messages,
                        status: 'failed'
                  },status: :unprocessable_entity
                end
            else 
                render json: {
                   message: "Failed to reject job"
                }
            end
        else
            render json: {
                message: "This job application does not belong to you"
            }
        end
    rescue ActiveRecord::RecordNotFound => error
        render json: {
            data: error.message, 
            status: :unauthorized
        }
    end
end
