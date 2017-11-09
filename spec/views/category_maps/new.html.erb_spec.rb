require 'rails_helper'

RSpec.describe "category_maps/new", type: :view do
  before(:each) do
    assign(:category_map, CategoryMap.new(
      :kktwon_category => "MyString",
      :kktwon_sub_category => "MyString",
      :carousell_category => "MyString",
      :carousell_sub_category => "MyString",
      :carousell_category_id => "MyString"
    ))
  end

  it "renders new category_map form" do
    render

    assert_select "form[action=?][method=?]", category_maps_path, "post" do

      assert_select "input[name=?]", "category_map[kktwon_category]"

      assert_select "input[name=?]", "category_map[kktwon_sub_category]"

      assert_select "input[name=?]", "category_map[carousell_category]"

      assert_select "input[name=?]", "category_map[carousell_sub_category]"

      assert_select "input[name=?]", "category_map[carousell_category_id]"
    end
  end
end
