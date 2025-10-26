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
end
