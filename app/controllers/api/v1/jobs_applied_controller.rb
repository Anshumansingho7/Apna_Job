class Api::V1::JobsAppliedController < ApplicationController

  include RoleDefined
  include NotFound

  def index 
    return unless job_seeker_role
    job_applieds = JobApplied.where(job_seeker_id: current_user.job_seeker.id)
    render json: job_applieds
  end
end
