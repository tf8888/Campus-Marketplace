require 'rails_helper'

RSpec.describe "Profiles", type: :request do
  let(:user) { create(:user) }

  before do
    allow_any_instance_of(ProfilesController).to receive(:authenticate_user!).and_return(true)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  describe "GET /profile" do
    it "redirects to /profile/edit" do
      get profile_path
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(edit_profile_path)
    end
  end

  describe "GET /profile/edit" do
    it "returns http success" do
      get edit_profile_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /profile" do
    it "updates the profile and redirects" do
      patch profile_path, params: { user: { name: "New Name" } }
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(edit_profile_path)
    end
  end
end
