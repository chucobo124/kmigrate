class CreateImages < ActiveRecord::Migration[5.1]
  def change
    create_table :images do |t|
      t.string :uri
      t.string :filename
      t.integer :size
      t.integer :image_class
      t.boolean :is_download , default: false

      t.timestamps
    end
  end
end
