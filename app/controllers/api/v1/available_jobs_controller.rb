class Api::V1::AvailableJobsController < ApplicationController
    def index
        if current_user.role === "job_seeker"
            job_seeker = current_user.job_seeker
            jobs = Job.where(field: job_seeker.job_field, skills_required: job_seeker.skills)
            render json: {
               jobs: jobs 
            }
        else
            render json: {
                message: "You cannot create company your role is seeeker"
            }
        end
    end
end