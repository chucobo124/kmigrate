require 'rails_helper'

RSpec.describe "users/show", type: :view do
  before(:each) do
    @user = assign(:user, User.create!(
      :carousell_user => "Carousell User",
      :kktown_user => "Kktown User",
      :serial_number => "Serial Number"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Carousell User/)
    expect(rendered).to match(/Kktown User/)
    expect(rendered).to match(/Serial Number/)
  end
end
