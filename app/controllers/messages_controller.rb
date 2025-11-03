class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_request

  def create
    @message = @request.messages.build(message_params)
    @message.sender = current_user
    @message.receiver = if @request.user == @message.sender
      @request.item.user
    else
      @request.user
    end

    if @message.save
      respond_to do |format|
        format.turbo_stream
        format.json { render json: { message: "Message sent successfully" }, status: :ok }
        format.html { redirect_to request_path(@request), notice: "Message sent successfully." }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("new_message_form", partial: "messages/form", locals: { request: @request, message: @message }) }
        format.json { render json: { error: @message.errors.full_messages }, status: :unprocessable_entity }
        format.html { redirect_to request_path(@request), alert: "Failed to send message." }
      end
    end
  end

  private

  def set_request
    @request = Request.find(params[:request_id])
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
