# Preview all emails at http://localhost:3000/rails/mailers/notification_mailer
class NotificationMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/notification_mailer/registration
  def registration
    NotificationMailer.registration
  end

  # Preview this email at http://localhost:3000/rails/mailers/notification_mailer/password_change
  def password_change
    NotificationMailer.password_change
  end

  # Preview this email at http://localhost:3000/rails/mailers/notification_mailer/job_approved
  def job_approved
    NotificationMailer.job_approved
  end

  # Preview this email at http://localhost:3000/rails/mailers/notification_mailer/job_rejected
  def job_rejected
    NotificationMailer.job_rejected
  end

end
