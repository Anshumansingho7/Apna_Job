class Api::V1::SearchJobController < ApplicationController

    def index
        @parameter = params[:search].downcase
        @job_recruiter = JobRecruiter.where("lower(name) LIKE ? OR lower(address) LIKE ? OR lower(Gst_no) LIKE ? OR lower(phone_no) LIKE ?", "#{@parameter}%", "#{@parameter}%", "#{@parameter}%", "#{@parameter}%")
        @job_seeker = JobSeeker.where("lower(name) LIKE ? OR lower(qualification) LIKE ? OR lower(skills) LIKE ? OR lower(hobbies) LIKE ? OR lower(address) LIKE ? OR lower(phone_no) LIKE ? OR lower(experience) LIKE ? OR lower(job_field) LIKE ?", "#{@parameter}%", "#{@parameter}%", "#{@parameter}%", "#{@parameter}%", "#{@parameter}%", "#{@parameter}%", "#{@parameter}%", "#{@parameter}%")
        @job = Job.where("lower(field) LIKE ? OR lower(experience_required) LIKE ? OR lower(salary) LIKE ? OR lower(skills_required) LIKE ?", "#{@parameter}%", "#{@parameter}%", "#{@parameter}%", "#{@parameter}%")            
        render json: {
            job_recruiter: @job_recruiter,
            job_seekeer: @job_seeker,
            job: @job
        }
    end
end
