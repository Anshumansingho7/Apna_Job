module NotFound
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  end

  private

  def record_not_found(error)
    render json: { error: error.message }, status: :not_found
  end
end
