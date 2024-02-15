class Api::V1::AvailableJobsController < ApplicationController

  include RoleDefined
  include NotFound

  def index
    return unless job_seeker_role
    job_seeker = current_user.job_seeker
    if job_seeker.present?
      jobs = Job.where(field: job_seeker.job_field, skills_required: job_seeker.skills)
      render json: {
        jobs: jobs 
      }
    else
      render json: {
      message: "Sorry there is no job available according to your skills"
      }
    end
  end
end