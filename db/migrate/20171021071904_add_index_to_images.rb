class AddIndexToImages < ActiveRecord::Migration[5.1]
  def change
    add_belongs_to :images, :user_item
  end
end
