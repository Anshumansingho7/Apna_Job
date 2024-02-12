class MyDevise::PasswordsController < ApplicationController
    before_action :authenticate_user!, except: [:update, :updatepassword]
    skip_before_action :check_jwt_payload


    respond_to :json

    def update
      jwt_payload = JWT.decode(request.headers["authorization"].split(' ')[1], Rails.application.credentials.fetch(:secret_key_base)).first
      current_user = User.find(jwt_payload['sub'])
      user = User.find_by(id: params[:id])
      if user
        reset_token = SecureRandom.urlsafe_base64.to_s
        user.update(reset_password_token: reset_token, reset_password_sent_at: Time.now)
        NotificationMailer.password_change(reset_token).deliver_now
        render json: { message: 'Password reset email sent successfully' }, status: :ok
      else
        render json: { error: 'User not found' }, status: :not_found
      end
    end

    def updatepassword
      jwt_payload = JWT.decode(request.headers["authorization"].split(' ')[1], Rails.application.credentials.fetch(:secret_key_base)).first
      current_user = User.find(jwt_payload['sub'])
      user = User.find_by(reset_password_token: params[:reset_token])
      if user && user.reset_password_sent_at.present? && user.reset_password_sent_at > 2.hours.ago
        if user.update_password_without_current(password_params)
          render json: { 
            message: 'Password updated successfully' 
          }, status: :ok
        else
          render json: { 
            errors: user.errors.full_messages 
          }, status: :unprocessable_entity
        end
      else
        render json: { error: 'Invalid or expired reset token' }, status: :unprocessable_entity
      end
    end

    private

    def password_params
        params.require(:user).permit(:password, :password_confirmation)
    end

    def check_jwt_payload
        if request.headers["authorization"].present? && request.headers["authorization"].include?("Bearer")
            #jwt_payload = JWT.decode(request.headers["authorization"].split(' ')[1], Rails.application.credentials.fetch(:secret_key_base)).first
            jwt_token = request.headers["authorization"].split(' ').last
            jwt_payload = JWT.decode(jwt_token, Rails.application.credentials.fetch(:secret_key_base)).first
            current_user = User.find(jwt_payload['sub'])
        else
            render json: { error: "Unauthorized" }, status: :unauthorized
        end
    end
    
end
