class Api::V1::ApplyJobsController < ApplicationController

    def create
        if current_user.role === "job_seeker"
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
                status: "pending"
                )
            
            job_recruiter = JobRecruiter.find_by(id:  job.job_recruiter_id)
            
            
            if job_application.save
                notification = Notification.new(
                    user_id: job_recruiter.user_id,
                    discription: "you have a new job application"
                )
                if notification.save
                else 
                    render json: {
                        data: notification.errors.full_messages,
                        status: 'failed'
                    },status: :unprocessable_entity
                end
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
                    status: "pending"
                )
                if job_applied.save
                    notification = Notification.new(
                        user_id: current_user.id,
                        discription: "your job appilication submitted succesfully"
                    )
                    if notification.save
                    else 
                        render json: {
                            data: notification.errors.full_messages,
                            status: 'failed'
                        },status: :unprocessable_entity
                    end
                    render json: {
                      message: "Job application created successfully"
                    },status: 200
                else
                    render json: {
                      message: "Failed to create job application",
                    }, status: :unprocessable_entity
                end
            end
        else
            render json: {
                message: "You cannot create company your role is recuiter"
            }
        end
    rescue ActiveRecord::RecordNotFound => error
        render json: {
            data: error.message, 
            status: :unauthorized
        },status: 404
    end
    


end