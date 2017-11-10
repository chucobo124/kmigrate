require 'kktown/user_items.rb'
namespace :user_items do
  desc 'Upload User Items to Carousell'
  task upload_product: :environment do
    process_name = 'UploadProduct'
    puts Logs::START_PROCESS % process_name
    User.all[6].user_items.un_uploaded.each do |user_item|
      # UserItem.un_uploaded.each do |user_item|
      next unless user_item.images.present?
      category_map = CategoryMap.find_by(kktwon_sub_category: user_item.category_lv2)
      next unless category_map.present?
      KAPI::UserItems.new.upload_items(user_item, category_map.carousell_category_id)
      sleep(1)
      user_item.update(is_uploaded: true)
    end
    puts Logs::COMPLETED % process_name
  end
end
