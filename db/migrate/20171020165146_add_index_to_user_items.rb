class AddIndexToUserItems < ActiveRecord::Migration[5.1]
  def change
    add_reference :user_items, :user
    add_reference :user_items, :images
  end
end
