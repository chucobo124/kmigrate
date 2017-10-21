require 'rails_helper'

RSpec.describe "users/new", type: :view do
  before(:each) do
    assign(:user, User.new(
      :carousell_user => "MyString",
      :kktown_user => "MyString",
      :serial_number => "MyString"
    ))
  end

  it "renders new user form" do
    render

    assert_select "form[action=?][method=?]", users_path, "post" do

      assert_select "input[name=?]", "user[carousell_user]"

      assert_select "input[name=?]", "user[kktown_user]"

      assert_select "input[name=?]", "user[serial_number]"
    end
  end
end
