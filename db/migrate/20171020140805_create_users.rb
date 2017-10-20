class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :carousell_user
      t.string :string
      t.string :kktown_user
      t.string :string
      t.string :serial_number
      t.string :string

      t.timestamps
    end
  end
end
