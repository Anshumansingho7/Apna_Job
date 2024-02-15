class SendEmailJob < ApplicationJob

  def perform
    NotificationMailer.with(email: "ashaktawat43@gmail.com").registration.deliver_now
  end
end
