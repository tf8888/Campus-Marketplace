require 'rails_helper'

RSpec.describe DevelopmentController, type: :controller do
    describe "GET #login_as" do
    let(:user) { create(:user) } # assumes you have a User factory

    context "in development environment" do
    before do
        allow(Rails.env).to receive(:development?).and_return(true)
    end

    it "sets the session user_id to the specified user" do
        get :login_as, params: { user_id: user.id }
        expect(session[:user_id]).to eq(user.id)
    end

    it "redirects to root_path with a notice" do
        get :login_as, params: { user_id: user.id }
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq("Logged in as #{user.name} (User ID: #{user.id})")
    end
    end

    context "not in development environment" do
    before do
        allow(Rails.env).to receive(:development?).and_return(false)
    end

    it "does not set the session and redirects with an alert" do
        get :login_as, params: { user_id: user.id }
        expect(session[:user_id]).to be_nil
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("Access denied.")
    end
    end

    context "when user does not exist" do
    before do
        allow(Rails.env).to receive(:development?).and_return(true)
    end

    it "raises ActiveRecord::RecordNotFound" do
        expect {
        get :login_as, params: { user_id: 0 }
        }.to raise_error(ActiveRecord::RecordNotFound)
    end
    end
end
end
