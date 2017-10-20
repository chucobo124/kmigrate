require 'rails_helper'

RSpec.describe "users/show", type: :view do
  before(:each) do
    @user = assign(:user, User.create!(
      :carousell_user => "Carousell User",
      :string => "String",
      :kktown_user => "Kktown User",
      :string => "String",
      :serial_number => "Serial Number",
      :string => "String"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Carousell User/)
    expect(rendered).to match(/String/)
    expect(rendered).to match(/Kktown User/)
    expect(rendered).to match(/String/)
    expect(rendered).to match(/Serial Number/)
    expect(rendered).to match(/String/)
  end
end
