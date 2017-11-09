require 'rails_helper'

RSpec.describe "category_maps/show", type: :view do
  before(:each) do
    @category_map = assign(:category_map, CategoryMap.create!(
      :kktwon_category => "Kktwon Category",
      :kktwon_sub_category => "Kktwon Sub Category",
      :carousell_category => "Carousell Category",
      :carousell_sub_category => "Carousell Sub Category",
      :carousell_category_id => "Carousell Category"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Kktwon Category/)
    expect(rendered).to match(/Kktwon Sub Category/)
    expect(rendered).to match(/Carousell Category/)
    expect(rendered).to match(/Carousell Sub Category/)
    expect(rendered).to match(/Carousell Category/)
  end
end
