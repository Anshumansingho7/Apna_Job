class Api::V1::ApplyJobsController < ApplicationController

  include NotificationCreater
  include RoleDefined
  include NotFound

  def create
    return unless job_seeker_role
    job = Job.find(params[:job_id])
    job_seeker = current_user.job_seeker
    job_application = JobApplication.new(
      name: job_seeker.name,
      qualification: job_seeker.qualification,
      skills: job_seeker.skills,
      address: job_seeker.address,
      phone_no: job_seeker.phone_no,
      experience: job_seeker.experience,
      job_recruiter_id: job.job_recruiter_id,
      job_id: job.id,
      status: 'pending'
    )
    if job_application.save
      job_recruiter = JobRecruiter.find_by(id: job.job_recruiter_id)
      create_notification(job_recruiter.user_id, 'you have a new job application')
      create_job_applied(job_application, job, job_seeker,job_recruiter)
    end 
  end

  private

  def create_job_applied(job_application, job, job_seeker,job_recruiter)
    job_applied = JobApplied.new(
      company_name: job_recruiter.name,
      experience_required: job.experience_required,
      salary: job.salary,
      address: job_recruiter.address,
      field: job.field,
      skills_required: job.skills_required,
      job_seeker_id: job_seeker.id,
      job_id: job.id,
      job_application_id: job_application.id,
      status: 'pending'
    )
    if job_applied.save
      create_notification(current_user.id, 'your job appilication submitted succesfully')
      render json: {
        message: 'Job application created successfully'
      }, status: 200
    else
      render json: {
        message: 'Failed to create job application'
      }, status: :unprocessable_entity
    end
  end
end


