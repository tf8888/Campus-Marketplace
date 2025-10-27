require 'rails_helper'

RSpec.describe "requests/edit", type: :view do
  let(:request) {
    Request.create!()
  }

  before(:each) do
    assign(:request, request)
  end

  it "renders the edit request form" do
    render

    assert_select "form[action=?][method=?]", request_path(request), "post" do
    end
  end
end
