require 'rails_helper'

RSpec.describe "requests/index", type: :view do
  before(:each) do
    assign(:requests, [
      FactoryBot.create(:request),
      FactoryBot.create(:request)
    ])
  end

  it "renders a list of requests" do
    skip "requests/index view not implemented"
  end
end
