require 'rails_helper'

RSpec.describe "category_maps/edit", type: :view do
  before(:each) do
    @category_map = assign(:category_map, CategoryMap.create!(
      :kktwon_category => "MyString",
      :kktwon_sub_category => "MyString",
      :carousell_category => "MyString",
      :carousell_sub_category => "MyString",
      :carousell_category_id => "MyString"
    ))
  end

  it "renders the edit category_map form" do
    render

    assert_select "form[action=?][method=?]", category_map_path(@category_map), "post" do

      assert_select "input[name=?]", "category_map[kktwon_category]"

      assert_select "input[name=?]", "category_map[kktwon_sub_category]"

      assert_select "input[name=?]", "category_map[carousell_category]"

      assert_select "input[name=?]", "category_map[carousell_sub_category]"

      assert_select "input[name=?]", "category_map[carousell_category_id]"
    end
  end
end
