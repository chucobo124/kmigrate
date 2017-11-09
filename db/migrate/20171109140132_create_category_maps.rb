class CreateCategoryMaps < ActiveRecord::Migration[5.1]
  def change
    create_table :category_maps do |t|
      t.string :kktwon_category
      t.string :kktwon_sub_category
      t.string :carousell_category
      t.string :carousell_sub_category
      t.string :carousell_category_id

      t.timestamps
    end
  end
end
