require 'kktown/kapi.rb'
require 'net/http'
class KAPI::UserProfiles < KAPI
  PROFILE_API = ENV['PROFILE_API']
  def fetch_user_profile(serial_number)
    uri = URI(PROFILE_API % serial_number)
    JSON.parse(Net::HTTP.get(uri), symbolize_names: true)   
  end
end
