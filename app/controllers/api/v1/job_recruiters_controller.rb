class Api::V1::JobRecruitersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_Recuiter, only: [:show, :update]
    
    def show 
        render json: @job_recruiter
    end

    def create
        if current_user.role === "job_recruiter"
            if current_user.job_recruiter.present?
                render json: {
                    status: :unprocessable_entity
                } 
            else
                @job_recruiter = current_user.build_job_recruiter(job_recruiter_params)
                if @job_recruiter.save
                    render json: @job_recruiter, status: :ok
                else
                    render json: {
                        data: @job_recruiter.errors.full_messages,
                        status: 'failed'
                    },status: :unprocessable_entity
                end
            end
        else
            render json: {
                message: "You cannot create company your role is seeeker"
            }
        end
    end


    def update
        if @job_recruiter.update(job_recruiter_params)
            render json: @job_recruiter, status: :ok
        else
            render json: {
                data: @job_recruiter.errors.full_messages,
                status: 'failed'
            },status: :unprocessable_entity
        end
    end


    private

    def set_Recuiter
        @job_recruiter = current_user.job_recruiter
    rescue ActiveRecord::RecordNotFound => error
        render json: {
            data: error.message, 
            status: :unauthorized
        }
    end

    def job_recruiter_params
        params.require(:job_recruiter).permit(:Comapany_name, :address, :phone_no, :Gst_no)
    end
end