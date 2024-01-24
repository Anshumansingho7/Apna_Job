class Api::V1::ApprovedJobsController < ApplicationController

    def update 
        job_application = JobApplication.find(params[:id])
        job_applied = JobApplied.find_by(job_application_id: job_application.id)

        if job_application.update(status: "Approved") && job_applied.update(status: "Approved")
            render json: {
               message: "Job approved succesfully"
            }
        else 
            render json: {
               message: "Failed to approve job"
            }
        end
    end
end