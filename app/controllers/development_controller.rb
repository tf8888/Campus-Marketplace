class DevelopmentController < ApplicationController
  before_action :ensure_development_env

  def login_as
    user = User.find(params[:user_id])
    session[:user_id] = user.id

    redirect_to root_path, notice: "Logged in as #{user.name} (User ID: #{user.id})"
  end

  private

  def ensure_development_env
    redirect_to root_path, alert: "Access denied." unless Rails.env.development?
  end
end
