class CreateUserItems < ActiveRecord::Migration[5.1]
  def change
    create_table :user_items do |t|
      t.string :serial_number
      t.string :category_lv1
      t.string :category_lv2
      t.decimal :price
      t.decimal :original_price
      t.string :name
      t.text :description
      t.string :location

      t.timestamps
    end
  end
end
