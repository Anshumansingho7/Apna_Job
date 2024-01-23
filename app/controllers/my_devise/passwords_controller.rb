class MyDevise::PasswordsController < ApplicationController
    respond_to :json

    def edit
        # Render the password change form
    end

    def update
        jwt_payload = JWT.decode(request.headers["authorization"].split(' ')[1], Rails.application.credentials.fetch(:secret_key_base)).first
        current_user = User.find(jwt_payload['sub'])
        if current_user.update_with_password(password_params)
          bypass_sign_in(current_user)
          render json: { message: 'Password updated successfully' }, status: :ok
        else
          render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    private

    def password_params
        params.require(:user).permit(:current_password, :password, :password_confirmation)
    end
    
end
