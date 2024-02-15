class Api::V1::NotificationsController < ApplicationController
  include NotFound
  def index
    notifications = Notification.where(user_id: current_user.id).order(id: :desc)
    render json: notifications
  end
end
