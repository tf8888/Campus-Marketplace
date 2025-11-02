require "twilio-ruby"

class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def show
    redirect_to edit_profile_path
  end

  def edit
  end

  def update
    if @user.update(profile_params)
      redirect_to edit_profile_path, notice: "Your profile was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def send_verification_code
    if @user.contact_number.blank?
      return redirect_to edit_profile_path, alert: "Please add a contact number to your profile first."
    end

    begin
      client = Twilio::REST::Client.new(
        Rails.application.credentials.twilio[:account_sid],
        Rails.application.credentials.twilio[:auth_token]
      )

      service_sid = Rails.application.credentials.twilio[:verify_service_sid]

      formatted_number = "+1" + @user.contact_number.gsub(/\D/, "")

      client.verify.v2.services(service_sid)
                       .verifications
                       .create(to: formatted_number, channel: "sms")

      session[:verification_phone] = formatted_number
      redirect_to edit_profile_path, notice: "A verification code has been sent to your phone."

    rescue Twilio::REST::TwilioError => e
      redirect_to edit_profile_path, alert: "Error: #{e.message}"
    end
  end

  def check_verification_code
    code = params[:code]
    phone_number = session[:verification_phone]

    if code.blank?
      return redirect_to edit_profile_path, alert: "Please enter your verification code."
    end

    begin
      client = Twilio::REST::Client.new(
        Rails.application.credentials.twilio[:account_sid],
        Rails.application.credentials.twilio[:auth_token]
      )

      service_sid = Rails.application.credentials.twilio[:verify_service_sid]

      check = client.verify.v2.services(service_sid)
                             .verification_checks
                             .create(to: phone_number, code: code)

      if check.status == "approved"
        @user.update(verified: true)
        session.delete(:verification_phone)
        redirect_to edit_profile_path, notice: "Your phone number has been successfully verified!"
      else
        redirect_to edit_profile_path, alert: "Invalid code. Please try again."
      end
    rescue Twilio::REST::TwilioError => e
      redirect_to edit_profile_path, alert: "Error: #{e.message}"
    end
  end

  private

  def set_user
    @user = current_user
  end

  # Strong params: Only allow the fields we want to be editable
  def profile_params
    params.require(:user).permit(:name, :address, :contact_number)
  end
end
