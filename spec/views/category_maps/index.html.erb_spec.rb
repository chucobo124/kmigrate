require 'rails_helper'

RSpec.describe "category_maps/index", type: :view do
  before(:each) do
    assign(:category_maps, [
      CategoryMap.create!(
        :kktwon_category => "Kktwon Category",
        :kktwon_sub_category => "Kktwon Sub Category",
        :carousell_category => "Carousell Category",
        :carousell_sub_category => "Carousell Sub Category",
        :carousell_category_id => "Carousell Category"
      ),
      CategoryMap.create!(
        :kktwon_category => "Kktwon Category",
        :kktwon_sub_category => "Kktwon Sub Category",
        :carousell_category => "Carousell Category",
        :carousell_sub_category => "Carousell Sub Category",
        :carousell_category_id => "Carousell Category"
      )
    ])
  end

  it "renders a list of category_maps" do
    render
    assert_select "tr>td", :text => "Kktwon Category".to_s, :count => 2
    assert_select "tr>td", :text => "Kktwon Sub Category".to_s, :count => 2
    assert_select "tr>td", :text => "Carousell Category".to_s, :count => 2
    assert_select "tr>td", :text => "Carousell Sub Category".to_s, :count => 2
    assert_select "tr>td", :text => "Carousell Category".to_s, :count => 2
  end
end
