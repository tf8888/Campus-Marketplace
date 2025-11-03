# filepath: /home/arkel/code/CSCE606-group5-project2/spec/controllers/message_controller_spec.rb
require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
  describe 'POST #create' do
    let(:owner) { create(:user) }
    let(:requester) { create(:user) }
    let(:category) { create(:category) }
    let(:item) { create(:item, user: owner, category: category) }
    let(:request_record) { create(:request, user: requester, item: item) }
    let(:valid_params) { { request_id: request_record.id, message: { content: 'Hello!' } } }

    context 'when the sender is the request owner' do
      before do
        allow(controller).to receive(:current_user).and_return(requester)
      end
      it 'sends a message successfully' do
        post :create, params: valid_params, as: :json

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Message sent successfully')
        expect(Message.last.sender).to eq(requester)
        expect(Message.last.receiver).to eq(owner)
        expect(Message.last.content).to eq('Hello!')
      end
    end

    context 'when the sender is the item owner' do
      before do
        allow(controller).to receive(:current_user).and_return(owner)
      end

      it 'sends a message successfully' do
        post :create, params: valid_params, as: :json

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Message sent successfully')
        expect(Message.last.sender).to eq(owner)
        expect(Message.last.receiver).to eq(requester)
        expect(Message.last.content).to eq('Hello!')
      end
    end

    context 'when the message fails to save' do
      before do
        allow(controller).to receive(:current_user).and_return(owner)
        allow_any_instance_of(Message).to receive(:save).and_return(false)
        allow_any_instance_of(Message).to receive_message_chain(:errors, :full_messages).and_return([ 'Error saving message' ])
      end

      it 'returns an error response' do
        post :create, params: valid_params, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to include('Error saving message')
      end
    end
  end
end
