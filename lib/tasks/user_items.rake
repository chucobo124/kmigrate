require 'kktown/user_items.rb'
namespace :user_items do
  desc 'Upload User Items to Carousell'
  task upload_product: :environment do
    process_name = 'UploadProduct'
    puts Logs::START_PROCESS % process_name
    loop do
      total_pages = UserItem.un_uploaded.page(1).total_pages
      total_pages.times.each do |page_number|
        UserItem.un_uploaded.page(page_number + 1).each do |user_item|
          unless user_item.images.present?
  	    puts "Images doesn\'t Exist"
            next
	  end
          category_map = CategoryMap.find_by(kktwon_sub_category: user_item.category_lv2)
	  unless category_map.present?
            puts 'Category'+ user_item.category_lv2.to_s + 'Map doesn\'t exit'
            next
          end
          if user_item.user.token.nil?
	    puts 'Token missing: User ID =>' + user_item.user.id.to_s
            next
	  end 
          KAPI::UserItems.new.upload_items(user_item, category_map.carousell_category_id)
          sleep(1)
        end
      end
      puts Logs::COMPLETED % process_name
    end
  end
end
