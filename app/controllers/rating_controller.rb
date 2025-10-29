class RatingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_request

  def new
    @rating = Rating.new
    authorize_rating
  end

  def create
    @rating = @request.build_rating(rating_params)
    @rating.rater = current_user
    @rating.ratee = @request.item.user
    
    authorize_rating

    if @rating.save
      redirect_to request_path(@request), notice: 'Thank you for your rating!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_request
    @request = Request.find(params[:request_id])
  end

  def rating_params
    params.require(:rating).permit(:score)
  end
  
  def authorize_rating
    unless @request.user == current_user
      redirect_to root_path, alert: 'You are not authorized to perform this action.'
      return
    end
    
    unless @request.status == 'approved'
      redirect_to request_path(@request), alert: 'You can only rate approved requests.'
      return
    end
    
    if action_name == 'new' && @request.rating.present?
      redirect_to request_path(@request), alert: 'You have already rated this transaction.'
    end
  end
end