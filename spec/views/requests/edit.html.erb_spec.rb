require 'rails_helper'

RSpec.describe "requests/edit", type: :view do
  let(:request) {
    FactoryBot.create(:request)
  }

  before(:each) do
    assign(:request, request)
  end

  it "renders the edit request form" do
    skip "requests/edit view not implemented"
  end
end
