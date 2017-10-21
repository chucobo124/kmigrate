require 'rails_helper'

RSpec.describe "users/edit", type: :view do
  before(:each) do
    @user = assign(:user, User.create!(
      :carousell_user => "MyString",
      :kktown_user => "MyString",
      :serial_number => "MyString"
    ))
  end

  it "renders the edit user form" do
    render

    assert_select "form[action=?][method=?]", user_path(@user), "post" do

      assert_select "input[name=?]", "user[carousell_user]"

      assert_select "input[name=?]", "user[kktown_user]"

      assert_select "input[name=?]", "user[serial_number]"
    end
  end
end
