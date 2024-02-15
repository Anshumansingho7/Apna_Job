class NotificationMailer < ApplicationMailer
  
  before_action :send_pic

  def registration()
    email = params[:email]
    attachments.inline['Terms_and_condition.pdf'] = File.read("Terms_and_condition.pdf")
    mail(to: email, subject: 'Welcome mail')
  end

  def password_change(reset_token)
    @reset_token = reset_token
    mail to: "ashaktawat43@gmail.com"
  end

  def job_approved(name, company_name)
    @name = name
    @company_name = company_name
    mail to: "ashaktawat43@gmail.com"
  end

  def job_rejected(name, company_name)
    @name = name
    @company_name = company_name
    mail to: "ashaktawat43@gmail.com"
  end

  private

  def send_pic 
    attachments.inline['Apna_job_logo.jpg'] = File.read("Apna_job_logo.jpg")
  end
end
