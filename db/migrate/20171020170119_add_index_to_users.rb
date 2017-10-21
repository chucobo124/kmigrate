class AddIndexToUsers < ActiveRecord::Migration[5.1]
  def change
    add_reference :statuses, :user
    add_reference :user_profiles, :user
  end
end
