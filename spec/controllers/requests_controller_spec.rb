require 'rails_helper'

RSpec.describe RequestsController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:item) { create(:item, user: other_user) }
  let(:own_item) { create(:item, user: user) }
  let(:request_record) { create(:request, user: user, item: item) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "GET #show" do
    context "when user owns the request" do
      it "renders show template" do
        get :show, params: { id: request_record.id }
        expect(response).to have_http_status(:ok)
        expect(assigns(:messages)).to eq(request_record.messages.order(created_at: :asc))
      end
    end
  end

  describe "POST #create" do
    context "valid request" do
      it "creates a new request" do
        expect {
          post :create, params: { request: { item_id: item.id, message: "Hi" } }
        }.to change(Request, :count).by(1)
        expect(response).to redirect_to(Request.last)
        expect(flash[:notice]).to eq("Request was successfully created.")
      end
    end
  end

  describe "DELETE #destroy" do
  context "when user owns the request" do
    it "destroys the request and redirects with notice" do
      request_record # create record
      expect {
        delete :destroy, params: { id: request_record.id }
      }.to change(Request, :count).by(-1)

      expect(response).to redirect_to(requests_user_path(user))
      expect(flash[:notice]).to eq("Request was successfully destroyed.")
      expect(response).to have_http_status(:see_other)
    end
  end
  end

  describe "PATCH #reject" do
    context "when current user owns the item" do
      let(:owned_item) { create(:item, user: user) }
      let(:pending_request) { create(:request, item: owned_item, status: "pending") }

      it "changes status to rejected and redirects with notice" do
        patch :reject, params: { id: pending_request.id }
        expect(pending_request.reload.status).to eq("rejected")
        expect(response).to redirect_to(request_path(pending_request))
        expect(flash[:notice]).to eq("Request rejected.")
      end

      it "does not reject if already approved" do
        approved_request = create(:request, item: owned_item, status: "approved")
        patch :reject, params: { id: approved_request.id }

        expect(approved_request.reload.status).to eq("approved")
        expect(response).to redirect_to(request_path(approved_request))
        expect(flash[:alert]).to eq("Only pending requests can be rejected.")
      end
    end

    context "when current user does not own the item" do
      it "redirects with access denied" do
        patch :reject, params: { id: request_record.id }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("Access denied.")
      end
    end
  end

  describe "PATCH #approve" do
    context "when current user owns the item" do
      let(:owned_item) { create(:item, user: user) }
      let(:pending_request) { create(:request, item: owned_item, status: "pending") }

      it "changes status to approved and redirects with notice" do
        patch :approve, params: { id: pending_request.id }
        expect(pending_request.reload.status).to eq("approved")
        expect(response).to redirect_to(request_path(pending_request))
        expect(flash[:notice]).to eq("Request approved.")
      end

      it "does not approve if already rejected" do
        rejected_request = create(:request, item: owned_item, status: "rejected")
        patch :approve, params: { id: rejected_request.id }

        expect(rejected_request.reload.status).to eq("rejected")
        expect(response).to redirect_to(request_path(rejected_request))
        expect(flash[:alert]).to eq("Only pending requests can be approved.")
      end
    end

    context "when current user does not own the item" do
      it "redirects with access denied" do
        patch :approve, params: { id: request_record.id }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("Access denied.")
      end
    end
  end

end