class Api::V1::JobsApplicationsController < ApplicationController

    def index 
        @job_applications = JobApplication.where(job_recruiter_id: current_user.job_recruiter.id)
        render json: @job_applications
    end
    
end