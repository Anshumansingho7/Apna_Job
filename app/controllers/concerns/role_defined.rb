module RoleDefined
  extend ActiveSupport::Concern
  def job_seeker_role
    unless current_user.role == "job_seeker"
      render json: {
        message: 'This job doesnot belong to you'
      }
      return false 
    end
    return true
  end

  def job_recruiter_role
    unless current_user.role == "job_recruiter"
      render json: {
        message: 'This job doesnot belong to you'
      }
      return false 
    end
    return true
  end


end