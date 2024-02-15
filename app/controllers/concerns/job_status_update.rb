module JobStatusUpdate
  extend ActiveSupport::Concern

  def check_job(job_application, job_applied, updated_status)
    return render_error("This job application does not belong to you") unless job_belongs_to_user?(job_application)

    if update_job_statuses(job_application, job_applied, updated_status)
      render_success("Job #{updated_status} successfully")
    else
      render_error("Failed to #{updated_status} job")
    end
  end

  private

  def job_belongs_to_user?(job_application)
    job_application.job_recruiter_id == current_user.job_recruiter.id
  end

  def update_job_statuses(job_application, job_applied, updated_status)
    job_application.transaction do
      job_application.update(status: updated_status) && job_applied.update(status: updated_status)
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  def render_success(message)
    render json: { message: message }
    true
  end

  def render_error(message)
    render json: { message: message }, status: :unprocessable_entity
    false
  end
end
