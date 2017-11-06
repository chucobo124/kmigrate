require 'kktown/user_items.rb'
namespace :user_items do
  desc 'Upload User Items to Carousell'
  task upload_product: :environment do
    process_name = 'UploadProduct'
    puts Logs::START_PROCESS % process_name
    UserItem.un_uploaded.each do |user_item|
      if user_item.images.present?
        KAPI::UserItems.new.upload_items(user_item, 1055)
        user_item.update(is_uploaded: true)
      end
    end
    puts Logs::COMPLETED % process_name
  end
end
