class Api::V1::AvailableJobsController < ApplicationController
    def index
        if current_user.role === "job_seeker"
            job_seeker = current_user.job_seeker
            jobs = Job.where(field: job_seeker.job_field, skills_required: job_seeker.skills)
            render json: {
               jobs: jobs 
            },status: 200
        else
            render json: {
                message: "Sorry there is no job available for you"
            },status: 404
        end
    rescue ActiveRecord::RecordNotFound => error
        render json: {
            data: error.message, 
            status: :unauthorized
        },status: 404
    end
end