class SendEmailJob < ApplicationJob
  queue_as :default

  def perform(email)
    # Do something later
    NotificationMailer.with(email: email).registration.deliver_now
  end
end
