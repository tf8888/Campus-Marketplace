require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  let!(:item1) { create(:item, user: user) }
  let!(:item2) { create(:item, user: user) }
  let!(:other_item) { create(:item, user: other_user) }

  describe "GET #show" do
    context "when user is not authenticated" do
      it "redirects to the login path" do
        get :show, params: { id: user.to_param }
        expect(response).to redirect_to(login_path)
      end
    end

    context "when user is authenticated" do
      before do
        allow(controller).to receive(:authenticate_user!).and_return(true)
        allow(controller).to receive(:current_user).and_return(create(:user))

        get :show, params: { id: user.to_param }
      end

      it "assigns the requested user to @user" do
        expect(assigns(:user)).to eq(user)
      end

      it "assigns the correct items to @items" do
        expect(assigns(:items)).to include(item1, item2)
      end

      it "does not assign other users' items to @items" do
        expect(assigns(:items)).not_to include(other_item)
      end

      it "renders the :show template" do
        expect(response).to render_template(:show)
      end
    end
  end

  describe "GET #incoming_requests" do
    let!(:incoming_req1) { create(:request, item: item1, user: other_user, status: 'pending') }
    let!(:incoming_req2) { create(:request, item: item2, user: other_user, status: 'approved') }
    let!(:other_incoming) { create(:request, item: other_item, user: user, status: 'pending') }

    context "when user is not authenticated" do
      it "redirects to the login path" do
        get :incoming_requests, params: { id: user.to_param }
        expect(response).to redirect_to(login_path)
      end
    end

    context "when user is authenticated as the owner" do
      before do
        allow(controller).to receive(:authenticate_user!).and_return(true)
        allow(controller).to receive(:current_user).and_return(user)

        get :incoming_requests, params: { id: user.to_param }
      end

      it "assigns only requests for the user's items to @incoming_requests" do
        expect(assigns(:incoming_requests)).to include(incoming_req1, incoming_req2)
        expect(assigns(:incoming_requests)).not_to include(other_incoming)
      end

      it "renders the incoming_requests template" do
        expect(response).to render_template(:incoming_requests)
      end
    end

    context "when viewing another user's incoming requests" do
      before do
        allow(controller).to receive(:authenticate_user!).and_return(true)
        allow(controller).to receive(:current_user).and_return(other_user)
      end

      it "redirects with access denied" do
        get :incoming_requests, params: { id: user.to_param }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("Access denied.")
      end
    end
  end
end
