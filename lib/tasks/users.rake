require 'kktown/user_profile.rb'
require 'json'
K_API = KAPI.new
UUID = SecureRandom.uuid.to_s
LOG_START_PROCESS =  UUID +  '===> Start %s ---' + Time.now.to_s
LOG_FETCH_URL = UUID + '===> Fetch url Serial_Number %s ---' + Time.now.to_s
LOG_UPDATE_TABLE = UUID + '===> Update %s table %s ---' + Time.now.to_s
LOG_SLEEP = UUID + '===> Completed Sleep %s second ---' + Time.now.to_s
LOG_COMPLETED = UUID + '===> Completed %s ---' + Time.now.to_s
LOG_PROCESS_FAILD = UUID + '===> Processing %s Error--- Serial_Number: %s ' + Time.now.to_s

namespace :users do
  desc 'get user profile and save to database'
  task get_user_profile: :environment do
    process_name = 'get_user_profile'
    puts LOG_START_PROCESS % process_name

    Status.un_profile_users.each do |status|
      user = status.user
      serial_number = user.serial_number

      # Fetch URL
      puts LOG_FETCH_URL % serial_number
      user_profile = K_API.fetch_user_profile(serial_number)

      if user_profile[:id].present?
        user_profile[:kk_id] = user_profile[:id]
      else
        puts format(LOG_PROCESS_FAILD, 'fetch_user_profile', serial_number)
      end

      dup_user_profile = user_profile.dup
      dup_user_profile.delete(:id)

      # Update Profile Table
      puts format(LOG_UPDATE_TABLE, 'Profile', serial_number)
      local_user_profile = user.create_user_profile(dup_user_profile)
      status.is_profile = true

      # Update Sataus Table
      puts format(LOG_UPDATE_TABLE, 'Sataus', serial_number)
      status.save

      # Sleep
      puts LOG_SLEEP % 'one'
      sleep(1)
    end

    puts LOG_COMPLETED % process_name
  end

  desc 'TODO'
  task get_user_profile_detail: :environment do
    # uuid = SecureRandom.uuid.to_s
    # puts uuid + '===> Start get_user_profile ---' + Time.now.to_s
    # puts('hello')
  end

  desc 'TODO'
  task get_user_items: :environment do
    puts('hello')
  end
end
