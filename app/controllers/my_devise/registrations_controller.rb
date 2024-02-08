class MyDevise::RegistrationsController < Devise::RegistrationsController
    before_action :configure_permitted_parameters
    respond_to :json
    
    private

    def respond_with(resource, options={})
      if resource.persisted?
        SendEmailJob.set(wait: 10.seconds).perform_later("ashaktawat43@gmail.com")
        #NotificationMailer.registration().deliver_now
        render json: {
          status: {code: 200, message: 'Signed up successfully'}
        }, status: :ok
      else
        render json: {
          status: { message: 'User could not be created successfully', 
          errors: resource.errors.full_messages}, status: :unprocessable_entity
        } 
      end
    end

    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :role])
    end
    
end
