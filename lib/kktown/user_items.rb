require 'kktown/kapi.rb'
class KAPI::UserItems < KAPI
  ITEMS_API = ENV['ITEMS_API']
  SIZE = 100
  def fetch_user_items(kk_id)
    uri = URI(format(ITEMS_API, kk_id, SIZE.to_s))
    user_items = JSON.parse(Net::HTTP.get(uri), symbolize_names: true)
    parse_user_items(user_items)
  end

  private

  def parse_user_items(user_items)
    unless user_items[:has_more]
      items = user_items[:items].map do |item|
        {
          serial_number: item[:serial_number],
          category_lv1: item[:category].try(:[], :name),
          category_lv2: item[:category_lv2].try(:[], :name),
          price: item[:price],
          original_price: item[:original_price],
          name: item[:name],
          description: item[:description],
          location: item[:location],
          cover_image: { normal: item[:cover_image].try(:[], :url_normal),
                         small: item[:cover_image].try(:[], :url_small) },
          images: item[:images].map do |image|
                    { small: image.try(:[], :url_small),
                      normal: image.try(:[], :url_normal) }
                  end
        }
      end
    end
  end
end
