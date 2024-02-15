class MyDevise::RegistrationsController < Devise::RegistrationsController
    before_action :configure_permitted_parameters
    respond_to :json
    skip_before_action :check_jwt_payload
   
    private

    def respond_with(resource, options={})
      if resource.persisted?
        SendEmailJob.set(wait: 10.seconds).perform_later()
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

    def check_jwt_payload
        if request.headers["authorization"].present? && request.headers["authorization"].include?("Bearer")
            #jwt_payload = JWT.decode(request.headers["authorization"].split(' ')[1], Rails.application.credentials.fetch(:secret_key_base)).first
            jwt_token = request.headers["authorization"].split(' ').last
            begin
              jwt_payload = JWT.decode(jwt_token, Rails.application.credentials.fetch(:secret_key_base)).first
              current_user = User.find(jwt_payload['sub'])
            rescue JWT::ExpiredSignature
              render json: { error: "Token has expired. Please log in again." }, status: :unauthorized
            end
        else
            render json: { error: "Unauthorized" }, status: :unauthorized
        end
    end 
end
