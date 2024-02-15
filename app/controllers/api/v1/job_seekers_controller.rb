class Api::V1::JobSeekersController < ApplicationController

  include NotificationCreater
  include RoleDefined
  include NotFound
  before_action :set_seeker, only: [:show, :update]
  def searchindex
    @parameter = params[:search].downcase
    column_name = params[:column_name]
    if column_name == nil
      job_seeker = JobSeeker.search(@parameter)
    else
      if JobSeeker.has_attribute?("#{column_name}")
        job_seeker = JobSeeker.where("lower(#{column_name}) LIKE ?","#{@parameter}%")
      end
    end
    render json: {
      job_seeker: job_seeker
    },status: 200
  end
  def shortingindex
    asds = params[:asds]
    column_name = params[:column_name]
    if JobSeeker.has_attribute?("#{column_name}")
      job_seeker = JobSeeker.all.order("#{column_name} #{asds} ")
    end
    render json: {
      job_seeker: job_seeker
    },status: 200
  end
  
  def show 
      render json: @job_seeker
  end

  def create 
    return unless job_seeker_role
    if current_user.job_seeker.present?
      render json: { error: "You have already added your details" }, status: :unprocessable_entity
      return
    end
    job_seeker = current_user.build_job_seeker(job_seeker_params)  
    if job_seeker.save
      create_notification(current_user.id, "your detail has succesfully saved")
      render json: job_seeker, status: :ok
    else
      render json: {
        data: job_seeker.errors.full_messages,
        status: 'failed'
      },status: :unprocessable_entity
    end
  end

  def update
    if @job_seeker.update(job_seeker_params)
      create_notification(current_user.id, "your detail has been succesfully updated")
      render json: @job_seeker, status: :ok
    else
      render json: {
          data: @job_seeker.errors.full_messages,
          status: 'failed'
      },status: :unprocessable_entity
    end
  end   

  private
  
  def set_seeker
    return unless job_seeker_role
    @job_seeker = current_user.job_seeker
  end

  def job_seeker_params
    params.require(:job_seeker).permit(:name, :address, :phone_no, :qualification, :skills, :hobbies, :experience, :job_field)
  end
end
