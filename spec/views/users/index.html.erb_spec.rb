require 'rails_helper'

RSpec.describe "users/index", type: :view do
  before(:each) do
    assign(:users, [
      User.create!(
        :carousell_user => "Carousell User",
        :kktown_user => "Kktown User",
        :serial_number => "Serial Number"
      ),
      User.create!(
        :carousell_user => "Carousell User",
        :kktown_user => "Kktown User",
        :serial_number => "Serial Number"
      )
    ])
  end

  it "renders a list of users" do
    render
    assert_select "tr>td", :text => "Carousell User".to_s, :count => 2
    assert_select "tr>td", :text => "Kktown User".to_s, :count => 2
    assert_select "tr>td", :text => "Serial Number".to_s, :count => 2
  end
end
