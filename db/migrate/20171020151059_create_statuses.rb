class CreateStatuses < ActiveRecord::Migration[5.1]
  def change
    create_table :statuses do |t|
      t.boolean :is_profile, default: false
      t.boolean :is_profile_detail, default: false
      t.boolean :is_user_item, default: false

      t.timestamps
    end
  end
end
