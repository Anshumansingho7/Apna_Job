class Api::V1::JobRecruitersController < ApplicationController
    before_action :set_Recuiter, only: [:show, :update]

    def searchindex
        @parameter = params[:search].downcase
        column_name = params[:column_name]
        job = Job.all
        if column_name == nil
            job_recruiter = JobRecruiter.search(@parameter)
        else
            if JobRecruiter.has_attribute?("#{column_name}")
                job_recruiter = JobRecruiter.where("lower(#{column_name}) LIKE ?","#{@parameter}%")
            end
        end
        render json: {
            job_recruiter: job_recruiter.as_json(include: 'job'),
        },status: 200
    end

    def shortingindex
        asds = params[:asds]
        column_name = params[:column_name]
        if JobRecruiter.has_attribute?("#{column_name}")
            job_recruiter = JobRecruiter.all.order("#{column_name} #{asds}")
        end
        render json: {
            job_recruiter: job_recruiter
        },status: 200
    end

    
    def show 
        render json: @job_recruiter
    end

    def create
        debugger
        if current_user.role === "job_recruiter"
            @job_recruiter = current_user.build_job_recruiter(job_recruiter_params)
            if @job_recruiter.save
                notification = Notification.new(
                    user_id: current_user.id,
                    discription: "your detail has succesfully saved"
                )
                notification.save
                render json: @job_recruiter, status: :ok
            else
                render json: {
                    data: @job_recruiter.errors.full_messages,
                    status: 'failed'
                },status: :unprocessable_entity
            end
        else
            render json: {
                message: "You cannot create company your role is seeeker"
            },status: 403
        end
    end


    def update
        if @job_recruiter.update(job_recruiter_params)
            notification = Notification.new(
                user_id: current_user.id,
                discription: "your detail has been succesfully updated"
            )
            notification.save
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
        },status: 404
    end

    def job_recruiter_params
        params.require(:job_recruiter).permit(:name, :address, :phone_no, :Gst_no)
    end
end