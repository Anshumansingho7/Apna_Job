class Api::V1::JobsController < ApplicationController
    
  include NotificationCreater
  include RoleDefined
  include NotFound

  before_action :authenticate_user!
  before_action :set_job, only: [:show, :update, :destroy]

  def index
    return unless job_recruiter_role
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
    return unless job_recruiter_role        
    @job=current_user.job_recruiter.job.new(job_params)
    if @job.save
      create_notification(current_user.id, "your job has been succesfully created")
      render json: @job, status: :ok
    else
      render json: {
        data: @job.errors.full_messages,
        status: 'failed'
      }
    end
  end

  def update
    if @job.update(job_params)
      create_notification(current_user.id, "your job has been succesfully updated")
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
      create_notification(current_user.id, "your job has been destroyed succesfully")
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
    return unless job_recruiter_role
    @job = Job.find(params[:id])
    unless @job.job_recruiter_id == current_user.job_recruiter.id
      render json: { 
        message: "You cannot access this job; it does not belong to you."
      }
    end
  end

  def job_params
    params.require(:jobs).permit(:field, :experience_required, :salary, :skills_required)
  end
end
