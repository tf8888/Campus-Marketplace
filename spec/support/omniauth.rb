require 'omniauth'

RSpec.configure do |config|
  config.before(:each) do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
      provider: 'google_oauth2',
      uid: 'uid-456',
      info: {
        email: 'new@student.edu',
        name: 'New Student'
      }
    )
  end

  config.after(:each) do
    OmniAuth.config.test_mode = false
    OmniAuth.config.mock_auth[:google_oauth2] = nil
  end
end
