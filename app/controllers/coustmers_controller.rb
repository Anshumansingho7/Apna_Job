class CoustmersController < ApplicationController
    before_action :authenticate_user!

    def index
        render json: current_user, status: :ok
    end

    def destroy
        user = current_user
        if user.destroy
            render json: {
                message: "Your Account deleted succesfully"
            }
        else
            render json: {
                message: "Your Account cannot deleted"
            }
        end
    end
end