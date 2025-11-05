require 'rails_helper'

RSpec.describe HomeController, type: :request do
  describe 'GET /' do
    context 'when not signed in' do
      it 'redirects to login with alert' do
        get root_path
        expect(response).to redirect_to(login_path)
        follow_redirect!
        # Flash alert is rendered via flash component; ensure presence of text
        expect(response.body).to include('You must sign in first.')
      end
    end

    context 'when signed in' do
      it 'renders the index page with user greeting' do
        # OmniAuth mock data is already configured in spec/support/omniauth.rb
        get "/auth/google_oauth2/callback"
        follow_redirect!

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Hello, New Student')
      end
    end
  end
end
