require 'rails_helper'

RSpec.describe "requests/show", type: :view do
  before(:each) do
    assign(:request, FactoryBot.create(:request))
  end

  it "renders attributes in <p>" do
    skip "requests/show view relies on current_user; skipping placeholder spec"
  end
end
