# spec/controllers/items_controller_spec.rb
require 'rails_helper'

RSpec.describe ItemsController, type: :controller do
  # --- Setup ---
  
  # Create a user and another user using FactoryBot
  # Assumes you have factories defined in spec/factories/users.rb
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }

  # Stub the current_user helper method
  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  # Define valid and invalid attributes for an item
  # Assumes you have an Item model with a :title validation
  # First, create a category that we can link to
  let!(:category) { FactoryBot.create(:category) }

  let(:valid_attributes) {
    { 
      title: 'Test Item', 
      description: 'A great item', 
      condition: 'Good', 
      location: 'Here',
      for_sale: true,
      for_lend: false,
      category_id: category.id 
    }
  }

  let(:invalid_attributes) {
    { title: '', description: 'Item with no title' }
  }

  # --- GET #index ---
  
  describe "GET #index" do
    let!(:books_category) { FactoryBot.create(:category, name: "Books") }
    let!(:other_category) { FactoryBot.create(:category, name: "Other") }

    let!(:item1) { FactoryBot.create(:item, title: 'Searchable Book', category: books_category, available: true) }
    let!(:item2) { FactoryBot.create(:item, title: 'Another Item', category: other_category, available: true) }
    let!(:item3) { FactoryBot.create(:item, title: 'Searchable Chair', category: books_category, available: false) }
    
    context "with a search query" do
      it "assigns only matching, available items to @items" do
        get :index, params: { query: 'Searchable' }
        expect(assigns(:items)).to include(item1)
        expect(assigns(:items)).not_to include(item2)
        expect(assigns(:items)).not_to include(item3)
      end
      
      it "assigns the search query to @search_query" do
        get :index, params: { query: 'Searchable' }
        expect(assigns(:search_query)).to eq('Searchable')
      end
    end

    context "without a search query" do
      it "assigns Item.none to @items" do
        get :index
        expect(assigns(:items)).to eq(Item.none)
      end
      
      it "assigns nil to @search_query" do
        get :index
        expect(assigns(:search_query)).to be_nil
      end
    end
  end

  # --- GET #my_listings ---

  describe "GET #my_listings" do
    let!(:my_item) { FactoryBot.create(:item, user: user) }
    let!(:other_item) { FactoryBot.create(:item, user: other_user) }

    it "assigns the current user's items to @my_items" do
      get :my_listings
      expect(assigns(:my_items)).to include(my_item)
      expect(assigns(:my_items)).not_to include(other_item)
    end
    
    it "renders the my_listings template" do
      get :my_listings
      expect(response).to render_template(:my_listings)
    end
  end

  # --- GET #show ---
  
  describe "GET #show" do
    let!(:my_item) { FactoryBot.create(:item, user: user, available: true) }
    let!(:unavailable_item) { FactoryBot.create(:item, user: other_user, available: false) }
    let!(:my_unavailable_item) { FactoryBot.create(:item, user: user, available: false) }

    it "assigns the requested item as @item" do
      get :show, params: { id: my_item.id }
      expect(assigns(:item)).to eq(my_item)
    end

    context "when item is unavailable and owned by another user" do
      it "redirects to items_path with an alert" do
        get :show, params: { id: unavailable_item.id }
        expect(response).to redirect_to(items_path)
        expect(flash[:alert]).to eq('This item is no longer available.')
      end
    end
    
    context "when item is unavailable but owned by current user" do
      it "shows the item successfully" do
        get :show, params: { id: my_unavailable_item.id }
        expect(assigns(:item)).to eq(my_unavailable_item)
        expect(response).to be_successful
      end
    end
  end

  # --- GET #new ---
  
  describe "GET #new" do
    it "assigns a new Item as @item" do
      get :new
      expect(assigns(:item)).to be_a_new(Item)
    end
  end

  # --- POST #create ---
  
  describe "POST #create" do
    context "with valid params" do
      it "creates a new Item" do
        expect {
          post :create, params: { item: valid_attributes }
        }.to change(Item, :count).by(1)
      end

      it "assigns the new item to the current user" do
        post :create, params: { item: valid_attributes }
        expect(Item.last.user).to eq(user)
      end

      it "redirects to the created item" do
        post :create, params: { item: valid_attributes }
        expect(response).to redirect_to(Item.last)
        expect(flash[:notice]).to eq('Item was successfully created.')
      end
    end

    context "with invalid params" do
      it "does not create a new Item" do
        expect {
          post :create, params: { item: invalid_attributes }
        }.not_to change(Item, :count)
      end

      it "re-renders the 'new' template with unprocessable_entity status" do
        post :create, params: { item: invalid_attributes }
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  # --- GET #edit ---
  
  describe "GET #edit" do
    let!(:my_item) { FactoryBot.create(:item, user: user) }
    let!(:other_item) { FactoryBot.create(:item, user: other_user) }

    it "assigns the requested item as @item" do
      get :edit, params: { id: my_item.id }
      expect(assigns(:item)).to eq(my_item)
    end

    it "redirects if user is not authorized" do
      get :edit, params: { id: other_item.id }
      expect(response).to redirect_to(items_path)
      expect(flash[:alert]).to eq('You are not authorized to modify this item.')
    end
  end

  # --- PATCH #update ---
  
  describe "PATCH #update" do
    let!(:my_item) { FactoryBot.create(:item, user: user, title: 'Original Title') }
    let!(:other_item) { FactoryBot.create(:item, user: other_user) }
    let(:new_attributes) { { title: 'Updated Title' } }

    context "when user is authorized" do
      context "with valid params" do
        it "updates the requested item" do
          patch :update, params: { id: my_item.id, item: new_attributes }
          my_item.reload
          expect(my_item.title).to eq('Updated Title')
        end

        it "redirects to the item" do
          patch :update, params: { id: my_item.id, item: new_attributes }
          expect(response).to redirect_to(my_item)
          expect(flash[:notice]).to eq('Item was successfully updated.')
        end
      end

      context "with invalid params" do
        it "re-renders the 'edit' template with unprocessable_entity status" do
          patch :update, params: { id: my_item.id, item: invalid_attributes }
          expect(response).to render_template(:edit)
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context "when user is not authorized" do
      it "redirects to items_path" do
        patch :update, params: { id: other_item.id, item: new_attributes }
        expect(response).to redirect_to(items_path)
        expect(flash[:alert]).to eq('You are not authorized to modify this item.')
      end
      
      it "does not update the item" do
        patch :update, params: { id: other_item.id, item: new_attributes }
        other_item.reload
        expect(other_item.title).not_to eq('Updated Title')
      end
    end
  end

  # --- DELETE #destroy ---
  
  describe "DELETE #destroy" do
    let!(:my_item) { FactoryBot.create(:item, user: user) }
    let!(:other_item) { FactoryBot.create(:item, user: other_user) }

    context "when user is authorized" do
      it "destroys the requested item" do
        expect {
          delete :destroy, params: { id: my_item.id }
        }.to change(Item, :count).by(-1)
      end

      it "redirects to the items list" do
        delete :destroy, params: { id: my_item.id }
        expect(response).to redirect_to(items_url)
        expect(flash[:notice]).to eq('Item was successfully deleted.')
      end
    end

    context "when user is not authorized" do
      it "does not destroy the item" do
        expect {
          delete :destroy, params: { id: other_item.id }
        }.not_to change(Item, :count)
      end

      it "redirects to items_path" do
        delete :destroy, params: { id: other_item.id }
        expect(response).to redirect_to(items_path)
        expect(flash[:alert]).to eq('You are not authorized to modify this item.')
      end
    end
  end
  
  # --- PATCH #mark_unavailable ---
  
  describe "PATCH #mark_unavailable" do
    let!(:my_item) { FactoryBot.create(:item, user: user, available: true) }
    let!(:other_item) { FactoryBot.create(:item, user: other_user, available: true) }

    context "when user is authorized" do
      it "updates the item's available status to false" do
        patch :mark_unavailable, params: { id: my_item.id }
        my_item.reload
        expect(my_item.available).to be(false)
      end

      it "redirects to the item" do
        patch :mark_unavailable, params: { id: my_item.id }
        expect(response).to redirect_to(my_item)
        expect(flash[:notice]).to eq('Item marked as unavailable.')
      end
    end

    context "when user is not authorized" do
      it "does not update the item" do
        patch :mark_unavailable, params: { id: other_item.id }
        other_item.reload
        expect(other_item.available).to be(true)
      end

      it "redirects to items_path" do
        patch :mark_unavailable, params: { id: other_item.id }
        expect(response).to redirect_to(items_path)
        expect(flash[:alert]).to eq('You are not authorized to modify this item.')
      end
    end
  end
end