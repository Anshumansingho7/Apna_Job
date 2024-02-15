module NotificationCreater
  extend ActiveSupport::Concern
  def create_notification(user_id, discription)
    notification = Notification.new(user_id: user_id, discription: discription)
    unless notification.save
      render json: {
        data: notification.errors.full_messages,
        status: 'failed'
      }, status: :unprocessable_entity
    end
  end
end