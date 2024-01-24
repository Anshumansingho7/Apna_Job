class Api::V1::RejectedJobsController < ApplicationController

    def update 
        job_application = JobApplication.find(params[:id])
        job_applied = JobApplied.find_by(job_application_id: job_application.id)

        if job_application.update(status: "Rejected") && job_applied.update(status: "Rejected")
            render json: {
               message: "Job Rejected succesfully"
            }
        else 
            render json: {
               message: "Failed to reject job"
            }
        end
    end
end
