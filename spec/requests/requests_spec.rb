require 'rails_helper'

RSpec.describe "/requests", type: :request do
  let(:user1) { User.create!(email: "requester@example.com", name: "Requester", role: "member", verified: true) }
  let(:user2) { User.create!(email: "owner@example.com", name: "Owner", role: "member", verified: true) }
  let(:category) { Category.create!(name: "Electronics") }
  let(:item) { Item.create!(title: "Test Item", user: user2, category: category, for_sale: true, price: 100, available: true, condition: "New") }

  let(:valid_attributes) {
    { item_id: item.id, user_id: user1.id, message: "I'd like to buy this", status: "pending" }
  }

  let(:invalid_attributes) {
    { item_id: nil, user_id: nil, message: "", status: "" }
  }

  before do
    allow_any_instance_of(ApplicationController).to receive(:authenticate_user!).and_return(true)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user1)
  end

  describe "GET /show" do
    it "renders a successful response for the requester" do
      request = Request.create! valid_attributes
      get request_url(request)
      expect(response).to be_successful
    end

    it "renders a successful response for the item owner" do
      request = Request.create! valid_attributes
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user2)
      get request_url(request)
      expect(response).to be_successful
    end

    it "redirects unauthorized users" do
      request = Request.create! valid_attributes
      other_user = User.create!(email: "other@example.com", name: "Other", role: "member", verified: true)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(other_user)
      get request_url(request)
      expect(response).to redirect_to(root_path)
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_request_url
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Request" do
        expect {
          post requests_url, params: { request: { item_id: item.id, message: "I want this" } }
        }.to change(Request, :count).by(1)
      end

      it "redirects to the created request" do
        post requests_url, params: { request: { item_id: item.id, message: "I want this" } }
        expect(response).to redirect_to(request_url(Request.last))
      end

      it "sets the current_user as the requester" do
        post requests_url, params: { request: { item_id: item.id, message: "I want this" } }
        expect(Request.last.user).to eq(user1)
      end

      it "sets status to pending" do
        post requests_url, params: { request: { item_id: item.id, message: "I want this" } }
        expect(Request.last.status).to eq("pending")
      end
    end

    context "with invalid parameters" do
      it "does not create a new Request without item_id" do
        expect {
          post requests_url, params: { request: { message: "I want this" } }
        }.to change(Request, :count).by(0)
      end

      it "renders a response with 422 status" do
        post requests_url, params: { request: { message: "I want this" } }
        expect(response).to have_http_status(:unprocessable_content)
      end

      it "does not allow requesting own item" do
        own_item = Item.create!(title: "My Item", user: user1, category: category, for_sale: true, price: 50, available: true, condition: "New")
        expect {
          post requests_url, params: { request: { item_id: own_item.id, message: "I want my own item" } }
        }.to change(Request, :count).by(0)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested request" do
      request = Request.create! valid_attributes
      expect {
        delete request_url(request)
      }.to change(Request, :count).by(-1)
    end

    it "redirects to the user's requests page" do
      request = Request.create! valid_attributes
      delete request_url(request)
      expect(response).to redirect_to(requests_user_path(user1))
    end

    it "does not allow other users to delete the request" do
      request = Request.create! valid_attributes
      other_user = User.create!(email: "other@example.com", name: "Other", role: "member", verified: true)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(other_user)
      
      expect {
        delete request_url(request)
      }.to change(Request, :count).by(0)
      expect(response).to redirect_to(root_path)
    end
  end

  describe "PATCH /approve" do
    it "approves a pending request" do
      request = Request.create! valid_attributes
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user2)
      
      patch approve_request_path(request)
      request.reload
      expect(request.status).to eq("approved")
      expect(response).to redirect_to(request_path(request))
    end

    it "does not allow non-owners to approve" do
      request = Request.create! valid_attributes
      # user1 is requester, not owner
      patch approve_request_path(request)
      request.reload
      expect(request.status).to eq("pending")
      expect(response).to redirect_to(root_path)
    end
  end

  describe "PATCH /reject" do
    it "rejects a pending request" do
      request = Request.create! valid_attributes
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user2)
      
      patch reject_request_path(request)
      request.reload
      expect(request.status).to eq("rejected")
      expect(response).to redirect_to(request_path(request))
    end

    it "does not allow non-owners to reject" do
      request = Request.create! valid_attributes
      # user1 is requester, not owner
      patch reject_request_path(request)
      request.reload
      expect(request.status).to eq("pending")
      expect(response).to redirect_to(root_path)
    end
  end
end
