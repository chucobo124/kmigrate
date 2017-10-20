require 'rails_helper'

RSpec.describe "users/index", type: :view do
  before(:each) do
    assign(:users, [
      User.create!(
        :carousell_user => "Carousell User",
        :string => "String",
        :kktown_user => "Kktown User",
        :string => "String",
        :serial_number => "Serial Number",
        :string => "String"
      ),
      User.create!(
        :carousell_user => "Carousell User",
        :string => "String",
        :kktown_user => "Kktown User",
        :string => "String",
        :serial_number => "Serial Number",
        :string => "String"
      )
    ])
  end

  it "renders a list of users" do
    render
    assert_select "tr>td", :text => "Carousell User".to_s, :count => 2
    assert_select "tr>td", :text => "String".to_s, :count => 2
    assert_select "tr>td", :text => "Kktown User".to_s, :count => 2
    assert_select "tr>td", :text => "String".to_s, :count => 2
    assert_select "tr>td", :text => "Serial Number".to_s, :count => 2
    assert_select "tr>td", :text => "String".to_s, :count => 2
  end
end
