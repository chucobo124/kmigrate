require 'net/http'
class KAPI
  PROFILE_API = ENV['PROFILE_API']
  def fetch_user_profile(serial_number)
    uri = URI(PROFILE_API % serial_number)
    JSON.parse(Net::HTTP.get(uri), symbolize_names: true)
    #     {
    #   "id": "53b66290-ad51-4ac2-87ed-4986b2ba977c",
    #   "serial_number": "A275983",
    #   "nickname": "DaDa",
    #   "profile_url": "https://kk.town/p/A275983",
    #   "avatar_url": "https://kktown.kfs.io/avatar/ic_avatar01_256.jpg",
    #   "avatar_url_small": "https://kktown.kfs.io/avatar/ic_avatar01_144.jpg",
    #   "avatar_url_normal": "https://kktown.kfs.io/avatar/ic_avatar01_256.jpg",
    #   "create_time": 1462773192401,
    #   "rating_good": 1,
    #   "rating_neutral": 0,
    #   "rating_bad": 0,
    #   "total_ratings": 1,
    #   "count_of_followers": 1,
    #   "count_of_followings": 0,
    #   "count_of_on_sale_items": 9,
    #   "count_of_sold_items": 1,
    #   "is_following": false
    # }
  end

  def fetch_user_items(serial); end
end
