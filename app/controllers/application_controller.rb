class ApplicationController < ActionController::API
    before_action :authenticate_user!
    before_action :check_jwt_payload

    private

    def check_jwt_payload        
      if request.headers["authorization"].present? && request.headers["authorization"].include?("Bearer")
        jwt_token = request.headers["authorization"].split(' ').last
        begin
          jwt_payload = JWT.decode(jwt_token, Rails.application.credentials.fetch(:secret_key_base)).first
          current_user = User.find(jwt_payload['sub'])
        rescue JWT::ExpiredSignature
          render json: { error: "Token has expired. Please log in again." }, status: :unauthorized
        rescue JWT::VerificationError
          render json: { error: "Jwt token Error" }, status: :unauthorized
        end
      else
        render json: { error: "Unauthorized" }, status: :unauthorized
      end
    end
end
