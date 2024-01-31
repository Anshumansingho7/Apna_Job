class Api::V1::JobsAppliedController < ApplicationController

    def index 
        job_applieds = JobApplied.where(job_seeker_id: current_user.job_seeker.id)
        render json: job_applieds
    end

end
