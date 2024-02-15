class Api::V1::JobRecruitersController < ApplicationController

  include NotificationCreater
  include RoleDefined
  include NotFound
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
    }
  end

  def shortingindex
    asds = params[:asds]
    column_name = params[:column_name]
    if JobRecruiter.has_attribute?("#{column_name}")
      job_recruiter = JobRecruiter.all.order("#{column_name} #{asds}")
    end
    render json: {
      job_recruiter: job_recruiter
    }
  end

  def show 
    render json: @job_recruiter
  end

  def create
    return unless job_recruiter_role
    if current_user.job_recruiter.present?
      render json: { error: "You have already added your details" }, status: :unprocessable_entity
      return
    end
    @job_recruiter = current_user.build_job_recruiter(job_recruiter_params)
    if @job_recruiter.save
      create_notification(current_user.id, "your detail has succesfully saved")
      render json: @job_recruiter, status: :ok
    else
      render json: {
        data: @job_recruiter.errors.full_messages,
        status: 'failed'
      },status: :unprocessable_entity
    end
  end

  def update
    if @job_recruiter.update(job_recruiter_params)
      create_notification(current_user.id, "your detail has been succesfully updated")
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
  end
  
  def job_recruiter_params
    params.require(:job_recruiter).permit(:name, :address, :phone_no, :Gst_no)
  end
end