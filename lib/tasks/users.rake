require 'kktown/user_profiles.rb'
require 'kktown/user_items.rb'
require 'json'
UUID = SecureRandom.uuid.to_s
LOG_START_PROCESS =  UUID +  '===> Start %s ---' + Time.now.to_s
LOG_FETCH_URL = UUID + '===> Fetch url--- Serial_Number/KKID: %s ---' + Time.now.to_s
LOG_UPDATE_TABLE = UUID + '===> Update %s table %s ---' + Time.now.to_s
LOG_SLEEP = UUID + '===> Completed Sleep %s second ---' + Time.now.to_s
LOG_COMPLETED = UUID + '===> Completed %s ---' + Time.now.to_s
LOG_PROCESS_FAILD = UUID + '===> Processing %s Error--- Serial_Number/KKID: %s ' + Time.now.to_s

namespace :users do
  desc 'get user profile and save to database'
  task get_user_profile: :environment do
    process_name = 'get_user_profile'
    kapi_user_profile = KAPI::UserProfiles.new
    puts LOG_START_PROCESS % process_name

    Status.un_profile.each do |status|
      user = status.user
      serial_number = user.serial_number
      next if serial_number.blank?

      # Fetch URL
      puts LOG_FETCH_URL % serial_number
      user_profile = kapi_user_profile.fetch_user_profile(serial_number)
      dup_user_profile = user_profile.dup

      if dup_user_profile[:id].present?
        dup_user_profile[:kk_id] = dup_user_profile[:id]
      else
        puts format(LOG_PROCESS_FAILD, 'fetch_user_profile', serial_number)
      end
      dup_user_profile.delete(:id)

      # Update Profile Table
      puts format(LOG_UPDATE_TABLE, 'Profile', serial_number)
      local_user_profile = user.create_user_profile(dup_user_profile)

      # Update Sataus Table
      puts format(LOG_UPDATE_TABLE, 'Sataus', serial_number)
      status.is_profile = true
      status.save

      # Sleep
      puts LOG_SLEEP % 'one'
      sleep(1)
    end

    puts LOG_COMPLETED % process_name
  end

  desc 'get user items and save to database'
  task get_user_items: :environment do
    process_name = 'get_user_items'
    kapi_user_items = KAPI::UserItems.new
    puts LOG_START_PROCESS % process_name

    Status.un_user_items.each do |status|
      user = status.user
      next if user.user_profile.blank?
      kk_id = user.user_profile.kk_id
      next if kk_id.blank?

      # Fetch URL
      puts LOG_FETCH_URL % kk_id
      user_items = kapi_user_items.fetch_user_items(kk_id)
      dup_user_items = user_items.dup

      dup_user_items.each do |user_item|
        # Update UserItems Table
        prepare_user_item = user_item.dup.without(:cover_image, :images)
        if UserItem.find_by(serial_number: prepare_user_item[:serial_number]).blank?
          puts format(LOG_UPDATE_TABLE, 'UserItems', kk_id)
          users_user_item = UserItem.new(prepare_user_item)
          user.user_items << users_user_item
        else
          next
        end

        # Update Images Table
        normal_cover_image_uri = user_item[:cover_image].try(:[], :normal)
        image_object = save_image(normal_cover_image_uri, :cover_image, :normal)
        users_user_item.images << image_object if image_object.present?

        # Update CoverImages to Images
        small_cover_image_uri = user_item[:cover_image].try(:[], :small)
        image_object = save_image(small_cover_image_uri, :cover_image, :small)
        users_user_item.images << image_object if image_object.present?

        # Update Images to Images
        user_item[:images].each do |image|
          small_image_uri = image[:small]
          image_object = save_image(small_image_uri, :images, :small)
          users_user_item.images << image_object if image_object.present?

          normal_image_uri = image[:normal]
          image_object = save_image(normal_image_uri, :images, :normal)
          users_user_item.images << image_object if image_object.present?
        end
      end

      # Update Sataus Table
      puts format(LOG_UPDATE_TABLE, 'Sataus', kk_id)
      status.is_user_item = true
      status.save

      # Sleep
      puts LOG_SLEEP % 'one'
      sleep(1)
    end

    puts LOG_COMPLETED % process_name
  end

  private

  def save_image(uri, image_class, size)
    return if uri.blank?
    filename = uri.split('/').last
    if Image.find_by(uri: uri).blank?
      puts format(LOG_UPDATE_TABLE, image_class.to_s + ' to Images', uri)
      image = Image.new(uri: uri, filename: filename, image_class: image_class, size: size)
    end
    image
  end
end
