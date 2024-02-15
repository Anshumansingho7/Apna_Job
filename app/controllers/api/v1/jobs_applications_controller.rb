class Api::V1::JobsApplicationsController < ApplicationController

  include RoleDefined
  include NotFound

  def index
    return unless job_recruiter_role
    job_applications = JobApplication.where(job_recruiter_id: current_user.job_recruiter.id)
    render json: job_applications
  end  
end