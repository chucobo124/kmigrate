class CreateUserProfiles < ActiveRecord::Migration[5.1]
  def change
    create_table :user_profiles do |t|
      t.string :kk_id
      t.string :serial_number
      t.string :nickname
      t.string :profile_url
      t.string :avatar_url
      t.string :avatar_url_small
      t.string :avatar_url_normal
      t.string :create_time
      t.integer :rating_good
      t.integer :rating_neutral
      t.integer :rating_bad
      t.integer :total_ratings
      t.integer :count_of_followers
      t.integer :count_of_followings
      t.integer :count_of_on_sale_items
      t.integer :count_of_sold_items
      t.boolean :is_following

      t.timestamps
    end
  end
end
