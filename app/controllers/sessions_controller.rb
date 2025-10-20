class SessionsController < ApplicationController
  def login
    # Just renders the login page with a Google login button
  end
  def create
    user_info = request.env['omniauth.auth']
    user = User.from_omniauth(user_info)
    session[:user_id] = user.id
    redirect_to root_path, notice: "Signed in as #{user.name}"
  end

  def destroy
    reset_session
    redirect_to root_path, notice: "Signed out!"
  end

  def failure
    redirect_to root_path, alert: "Authentication failed, please try again."
  end
end
