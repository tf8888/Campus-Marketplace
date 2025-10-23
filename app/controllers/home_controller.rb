class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user

    @items = Item.where(available: true)

    if params[:query].present?
      @items = @items.where("title ILIKE ? OR description ILIKE ?", "%#{params[:query]}%", "%#{params[:query]}%")
    end

    @items = @items.order(created_at: :desc)
  end
end
