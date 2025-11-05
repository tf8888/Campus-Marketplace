class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[ show items requests incoming_requests ]

  def show
    @items = @user.items.order(created_at: :desc)
  end

  def items
    @items = @user.items.order(created_at: :desc)
  end

  def requests
    redirect_to root_path, alert: "Access denied." unless @user == current_user
    @requests = @user.requests.order(created_at: :desc)
  end

  def incoming_requests
    redirect_to root_path, alert: "Access denied." unless @user == current_user
    @incoming_requests = Request.joins(:item).where(items: { user_id: @user.id }).order(created_at: :desc)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
