class MyDevise::SessionsController < Devise::SessionsController
    before_action :configure_permitted_parameters
    

    private

    def respond_with(resource, options={})
      render json: {
        status: { code: 200, message: 'Logged in successfully.' },
        data: current_user
      }, status: :ok
    end

    def respond_to_on_destroy
      jwt_payload = JWT.decode(request.headers["authorization"].split(' ')[1], Rails.application.credentials.fetch(:secret_key_base)).first
      current_user = User.find(jwt_payload['sub'])
      if current_user      
        sign_out(current_user)
        render json: {
          status: 200,
          message: 'Logged out successfully',
        }, status: :ok
      else
        render json: {
          status: 401,
          message: "Couldn't find an active session."
        }, status: :unauthorized
      end
    end

    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :role])
    end
end
