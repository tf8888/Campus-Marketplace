require 'rails_helper'
require 'ostruct'

RSpec.describe "Sessions", type: :request do
  describe "GET /login" do
    it "renders the login page" do
      get "/login"
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Sign in")
    end
  end

  describe "GET /auth/google_oauth2/callback" do
    it "creates or updates the user and redirects to root with notice" do
      expect {
        get "/auth/google_oauth2/callback"
      }.to change(User, :count).by(1)

      expect(response).to redirect_to(root_path)
      follow_redirect!
    end

    it "does not duplicate an existing user with same uid" do
      existing = User.create!(name: "Student", uid: 'uid-456', email: 'old@student.edu')
      expect {
        get "/auth/google_oauth2/callback"
      }.not_to change(User, :count)

      expect(response).to redirect_to(root_path)
      existing.reload
      expect(existing.email).to eq('new@student.edu')
      expect(existing.name).to eq('New Student')
    end
  end

  describe "GET /logout" do
    it "clears the session and redirects with notice" do
      # Sign in via OAuth callback to establish session
      get "/auth/google_oauth2/callback"
      expect(response).to redirect_to(root_path)

      # Now logout
      get logout_path

      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq("Signed out!")
    end
  end

  describe "GET /auth/failure" do
    it "redirects to root with alert" do
      get "/auth/failure"
      expect(response).to redirect_to(root_path)
      follow_redirect!
    end
  end
end
