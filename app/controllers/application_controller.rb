class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  helper_method :current_user, :user_signed_in?

  # Retrieves the currently logged-in user based on session data
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  # Simple boolean helper
  def user_signed_in?
    current_user.present?
  end

  # Ensures user is authenticated before accessing certain actions
  def authenticate_user!
    unless user_signed_in?
      redirect_to login_path, alert: "You must sign in first."
    end
  end
end
