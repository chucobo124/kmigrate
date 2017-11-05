class AddIsUploadedToUserItems < ActiveRecord::Migration[5.1]
  def change
    add_column :user_items, :is_uploaded, :boolean
  end
end
