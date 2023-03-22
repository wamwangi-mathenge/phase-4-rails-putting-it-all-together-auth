class SessionsController < ApplicationController
    def create
        user = User.find_by(username: params[:username])
        if user&.authenticate(params[:password])
            session[:user_id] = user.id
            render json: { id: user.id, username: user.username, image_url: user.image_url, bio: user.bio }, status: :created
        else
            render json: { error: "Invalid username or password" }, status: :unauthorized
        end
    end

    def destroy
        if session[:user_id]
            session.delete(:user_id)
            head :no_content
        else
            render json: { error: "Not authorized" }, status: :unauthorized
        end
    end
end
