class NotificationMailer < ApplicationMailer

  def registration()
    mail to: "to@example.org"
  end

  def password_change(reset_token)
    @reset_token = reset_token
    mail to: "to@example.org"
  end

  def job_approved(name, company_name)
    @name = name
    @company_name = company_name
    mail to: "to@example.org"
  end

  def job_rejected(name, company_name)
    @name = name
    @company_name = company_name
    mail to: "to@example.org"
  end
end
