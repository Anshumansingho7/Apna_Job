class NotificationMailer < ApplicationMailer


  def registration()
    attachments.inline['Apna_job_logo.jpg'] = File.read("Apna_job_logo.jpg")
    attachments.inline['Terms_and_condition.pdf'] = File.read("Terms_and_condition.pdf")
    #mailed = ["anshuman@webkorps.com", "anshumansinghshaktawat5@gmail.com"]
    #cc_recipients = ["ashaktawat43@gmail.com", "anshumanshaktawat980@gmail.com"]
    #mail(to: mailed , cc: cc_recipients)
    mail to: "ashaktawat43@gmail.com"
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
end
