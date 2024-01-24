class Api::V1::JobSeekersController < ApplicationController
    before_action :authenticate_user!


    before_action :set_seeker, only: [:show, :update]
    

    def show 
        render json: @job_seeker
    end

    def create 
        if current_user.job_seeker.present?
            render json: {
                status: :unprocessable_entity
            } 
        else
            @job_seeker = current_user.build_job_seeker(job_seeker_params)
            if @job_seeker.save
                render json: @job_seeker, status: :ok
            else
                render json: {
                    data: @job_seekers.errors.full_messages,
                    status: 'failed'
                },status: :unprocessable_entity
            end
        end
    end


    def update
        if @job_seeker.update(job_seeker_params)
            render json: @job_seeker, status: :ok
        else
            render json: {
                data: @job_seeker.errors.full_messages,
                status: 'failed'
            },status: :unprocessable_entity
        end
    end
    

    private

    def set_seeker
        @job_seeker = current_user.job_seeker
    rescue ActiveRecord::RecordNotFound => error
        render json: {
            data: error.message, 
            status: :unauthorized
        }
    end

    def job_seeker_params
        params.require(:job_seeker).permit(:name, :address, :phone_no, :qualification, :skills, :hobbies, :experience, :job_field)
    end

    #def authenticate_user!
    #    jwt_payload = JWT.decode(request.headers["authorization"].split(' ')[1], Rails.application.credentials.fetch(:secret_key_base)).first
    #    current_user = User.find(jwt_payload['sub'])
    #end
end
