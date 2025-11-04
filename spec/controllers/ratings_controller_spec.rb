require "rails_helper"

RSpec.describe RatingsController, type: :controller do
let(:request_user) { create(:user) }
let(:other_user) { create(:user) }
let(:item_owner) { create(:user) }
let(:item) { create(:item, user: item_owner) }
let(:approved_request) { create(:request, user: request_user, item: item, status: "approved") }
let(:pending_request) { create(:request, user: request_user, item: item, status: "pending") }

before do
allow(controller).to receive(:authenticate_user!).and_return(true)
allow(controller).to receive(:current_user).and_return(request_user)

@routes = ActionDispatch::Routing::RouteSet.new
@routes.draw do
  resources :requests do
    resource :rating, only: [:new, :create]
  end
  root to: "home#index"
  get "/login", to: "sessions#new"
end
controller.instance_variable_set(:@_routes, @routes)


end

describe "GET #new" do
context "when user is signed in" do
context "when request is not approved" do
it "redirects to request path with alert" do
get :new, params: { request_id: pending_request.id }
expect(response).to redirect_to(request_path(pending_request))
expect(flash[:alert]).to eq("You can only rate approved requests.")
end
end

  context "when another user tries to access" do
    before { allow(controller).to receive(:current_user).and_return(other_user) }

    it "redirects to root path" do
      get :new, params: { request_id: approved_request.id }
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("You are not authorized to perform this action.")
    end
  end

  context "when rating already exists" do
    before { create(:rating, request: approved_request, rater: request_user, ratee: item_owner, score: 7) }

    it "redirects with alert" do
      get :new, params: { request_id: approved_request.id }
      expect(response).to redirect_to(request_path(approved_request))
      expect(flash[:alert]).to eq("You have already rated this transaction.")
    end
  end
end

context "when user is not signed in" do
  before do
    allow(controller).to receive(:authenticate_user!).and_call_original
    allow(controller).to receive(:current_user).and_return(nil)
  end

  it "redirects to login page" do
    get :new, params: { request_id: approved_request.id }
    expect(response).to redirect_to("/login")
    expect(flash[:alert]).to eq("You must sign in first.")
  end
end


end

describe "POST #create" do
context "when user is signed in" do
context "with valid parameters" do
let(:valid_params) { { rating: { score: 8 }, request_id: approved_request.id } }

    it "creates a new rating" do
      expect {
        post :create, params: valid_params
      }.to change(Rating, :count).by(1)

      rating = Rating.last
      expect(rating.rater).to eq(request_user)
      expect(rating.ratee).to eq(item_owner)
      expect(response).to redirect_to(request_path(approved_request))
      expect(flash[:notice]).to eq("Thank you for your rating!")
    end
  end
end
end
end