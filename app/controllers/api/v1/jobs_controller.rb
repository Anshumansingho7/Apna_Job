class Api::V1::JobsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_job, only: [:show, :update, :destroy]

    def index
        @jobs = Job.where(job_recruiter_id: current_user.job_recruiter.id)
        render json: @jobs
    end

    def searchindex
        @parameter = params[:search].downcase
        column_name = params[:column_name]
        if column_name == nil
            job = Job.search(@parameter)
        else
            if Job.has_attribute?("#{column_name}")
                job = Job.where("lower(#{column_name}) LIKE ?","#{@parameter}%")
            end
        end
        render json: {
            job: job
        }
    end


    def shortingindex
        asds = params[:asds]
        column_name = params[:column_name]
        if Job.has_attribute?("#{column_name}")
            job = Job.all.order("#{column_name} #{asds} ")
        end
        render json: {
            job: job
        }
    end


    def show 
        render json: @job
    end

    def create 
        
        if current_user.role === "job_recruiter"
            # job_recruiter_id = current_user.job_recruiter.id
            # @job = Job.new(job_params.merge(job_recruiter_id: job_recruiter_id))
            if current_user.job_recruiter.exists?
                @job=current_user.job_recruiter.job.new(job_params)
                if @job.save
                    notification = Notification.new(
                        user_id: current_user.id,
                        discription: "your job has been succesfully created"
                    )
                    notification.save
                    render json: @job, status: :ok
                else
                    render json: {
                        data: @job.errors.full_messages,
                        status: 'failed'
                    },status: :unprocessable_entity
                end
            else
                render json: {
                    message: "You cannot create company please create company detail first"
                }
            end   
        else
            render json: {
                message: "You cannot create company your role is seeker"
            }
        end
    end


    def update
        if @job.update(job_params)
            notification = Notification.new(
                user_id: current_user.id,
                discription: "your job has been succesfully updated"
            )
            notification.save
            render json: @job, status: :ok
        else
            render json: {
                data: @job.errors.full_messages,
                status: 'failed'
            },status: :unprocessable_entity
        end
    end

    def destroy
        if @job.destroy
            render json: {
              message:  "job destroy succesfully"
            }
        else 
            render json: {
                data: @job.errors.full_messages,
            }, status: :unprocessable_entity
        end
    end
    private

    def set_job
        if current_user.role === "job_recruiter"
            @job = Job.find(params[:id])
            if @job.job_recruiter_id == current_user.job_recruiter.id

            else
                render json: { 
                  message: "You cannot access this job; it does not belong to you."
                }
            end
        else
            render json: {
                message: "You cannot create company your role is seeker"
            }
        end
    rescue ActiveRecord::RecordNotFound => error
        render json: {
            data: error.message, 
            status: :unauthorized
        }
    end

    def job_params
        params.require(:jobs).permit(:field, :experience_required, :salary, :skills_required)
    end

    #def authenticate_user!
    #    jwt_payload = JWT.decode(request.headers["authorization"].split(' ')[1], Rails.application.credentials.fetch(:secret_key_base)).first
    #    current_user = User.find(jwt_payload['sub'])
    #end
end
