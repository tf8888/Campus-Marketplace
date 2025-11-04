require "rails_helper"

RSpec.describe ProfilesController, type: :controller do
let(:user) { create(:user, name: "Test User", contact_number: "1234567890", verified: false) }

before do
allow(controller).to receive(:authenticate_user!).and_return(true)
allow(controller).to receive(:current_user).and_return(user)

fake_credentials = double("Credentials", twilio: {
  account_sid: "test_sid",
  auth_token: "test_token",
  verify_service_sid: "test_service_sid"
})
allow(Rails.application).to receive(:credentials).and_return(fake_credentials)


end

describe "GET #show" do
it "redirects to edit profile path" do
get :show
expect(response).to redirect_to(edit_profile_path)
end
end

describe "GET #edit" do
it "renders edit template" do
get :edit
expect(response).to render_template(:edit)
end
end

describe "PATCH #update" do
context "when valid params" do
it "updates the user and redirects with notice" do
patch :update, params: { user: { name: "Updated Name", contact_number: "0987654321" } }

    expect(response).to redirect_to(edit_profile_path)
    expect(flash[:notice]).to eq("Your profile was successfully updated.")
    user.reload
    expect(user.name).to eq("Updated Name")
  end
end

context "when invalid params" do
  it "renders edit with status 422" do
    patch :update, params: { user: { name: "" } }
    expect(response).to render_template(:edit)
    expect(response.status).to eq(422)
  end
end
end

describe "PATCH #send_verification_code" do
let(:mock_client) { instance_double(Twilio::REST::Client) }
let(:mock_services) { double("Services") }

before do
  allow(Twilio::REST::Client).to receive(:new).and_return(mock_client)
  allow(mock_client).to receive_message_chain(:verify, :v2, :services).and_return(mock_services)
end

it "sends SMS verification when contact number present" do
  expect(mock_services).to receive_message_chain(:verifications, :create)
    .with(to: "+11234567890", channel: "sms")

  patch :send_verification_code

  expect(response).to redirect_to(edit_profile_path)
  expect(flash[:notice]).to eq("A verification code has been sent to your phone.")
  expect(session[:verification_phone]).to eq("+11234567890")
end

it "redirects with alert when contact number blank" do
  user.update(contact_number: nil)
  patch :send_verification_code
  expect(response).to redirect_to(edit_profile_path)
  expect(flash[:alert]).to eq("Please add a contact number to your profile first.")
end

it "rescues from Twilio::REST::TwilioError gracefully" do
  allow(mock_services).to receive_message_chain(:verifications, :create)
    .and_raise(Twilio::REST::TwilioError.new("Failure"))

  patch :send_verification_code
  expect(response).to redirect_to(edit_profile_path)
  expect(flash[:alert]).to match(/Error: Failure/)
end
end

describe "POST #check_verification_code" do
let(:mock_client) { instance_double(Twilio::REST::Client) }
let(:mock_services) { double("Services") }

before do
  allow(Twilio::REST::Client).to receive(:new).and_return(mock_client)
  allow(mock_client).to receive_message_chain(:verify, :v2, :services).and_return(mock_services)
  session[:verification_phone] = "+11234567890"
end

it "redirects with alert when code blank" do
  post :check_verification_code, params: { code: "" }
  expect(response).to redirect_to(edit_profile_path)
  expect(flash[:alert]).to eq("Please enter your verification code.")
end

it "sets verified true on approved status" do
  allow(mock_services).to receive_message_chain(:verification_checks, :create)
    .and_return(OpenStruct.new(status: "approved"))

  post :check_verification_code, params: { code: "123456" }

  expect(response).to redirect_to(edit_profile_path)
  expect(flash[:notice]).to eq("Your phone number has been successfully verified!")
  user.reload
  expect(user.verified).to be true
  expect(session[:verification_phone]).to be_nil
end

it "sets alert on invalid code" do
  allow(mock_services).to receive_message_chain(:verification_checks, :create)
    .and_return(OpenStruct.new(status: "pending"))

  post :check_verification_code, params: { code: "000000" }

  expect(response).to redirect_to(edit_profile_path)
  expect(flash[:alert]).to eq("Invalid code. Please try again.")
  user.reload
  expect(user.verified).to be false
end

it "rescues from Twilio error" do
  allow(mock_services).to receive_message_chain(:verification_checks, :create)
    .and_raise(Twilio::REST::TwilioError.new("Down"))

  post :check_verification_code, params: { code: "123456" }

  expect(response).to redirect_to(edit_profile_path)
  expect(flash[:alert]).to include("Error: Down")
end
end

describe "private methods" do
it "sets user from current_user" do
controller.send(:set_user)
expect(assigns(:user)).to eq(user)
end

it "permits only allowed params" do
  params = ActionController::Parameters.new(
    user: { name: "John", address: "City", contact_number: "111", admin: true }
  )
  controller.params = params
  result = controller.send(:profile_params)
  expect(result.keys).to match_array(%w[name address contact_number])
end
end

describe "edge cases" do
it "formats complex phone numbers correctly" do
user.update(contact_number: "(123) 456-7890")

  mock_client = instance_double(Twilio::REST::Client)
  allow(Twilio::REST::Client).to receive(:new).and_return(mock_client)
  mock_services = double("Services")
  allow(mock_client).to receive_message_chain(:verify, :v2, :services).and_return(mock_services)
  allow(mock_services).to receive_message_chain(:verifications, :create).and_return(true)

  patch :send_verification_code
  expect(session[:verification_phone]).to eq("+11234567890")
end

end
end
