class RequestsController < ApplicationController
  before_action :set_request, only: %i[ show destroy approve reject ]

  # GET /requests/1 or /requests/1.json
  def show
    unless @request.user == current_user || @request.item.user == current_user
      redirect_back fallback_location: root_path, alert: "Access denied."
      return
    end
    @messages = @request.messages.order(created_at: :asc)
  end

  # GET /requests/new
  def new
    @request = Request.new
  end

  # POST /requests or /requests.json
  def create
    @request = Request.new(user: current_user, status: :pending, **request_params)
    unless @request.user == current_user
      redirect_back fallback_location: root_path, alert: "Access denied."
      return
    end

    respond_to do |format|
      if @request.save
        format.html { redirect_to @request, notice: "Request was successfully created." }
        format.json { render :show, status: :created, location: @request }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /requests/1 or /requests/1.json
  def destroy
    unless @request.user == current_user
      redirect_back fallback_location: root_path, alert: "Access denied."
      return
    end

    @request.destroy!

    respond_to do |format|
      format.html { redirect_to requests_user_path(current_user), notice: "Request was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  # PATCH /requests/:id/approve
  def approve
    unless @request.item.user == current_user
      return redirect_back fallback_location: root_path, alert: "Access denied."
    end

    if @request.status == "pending"
      @request.update!(status: "approved")
      redirect_to request_path(@request), notice: "Request approved."
    else
      redirect_to request_path(@request), alert: "Only pending requests can be approved."
    end
  end

  # PATCH /requests/:id/reject
  def reject
    unless @request.item.user == current_user
      return redirect_back fallback_location: root_path, alert: "Access denied."
    end

    if @request.status == "pending"
      @request.update!(status: "rejected")
      redirect_to request_path(@request), notice: "Request rejected."
    else
      redirect_to request_path(@request), alert: "Only pending requests can be rejected."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_request
      @request = Request.find(params.require(:id))
    end

    # Only allow a list of trusted parameters through.
    def request_params
      params.require(:request).permit(:item_id, :user_id, :message)
    end
end
