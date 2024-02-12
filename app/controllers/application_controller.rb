class ApplicationController < ActionController::API
    before_action :authenticate_user!
    before_action :check_jwt_payload


    private

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
