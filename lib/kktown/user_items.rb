require 'kktown/kapi.rb'
require 'net/http'
require 'net/http/post/multipart'
require 'open-uri'

class KAPI::UserItems < KAPI
  ITEMS_API = ENV['ITEMS_API']
  CREATE_PRODUCT_API = ENV['CREATE_PRODUCT_API']
  CAROUSELL_PRODUCTS = ENV['CAROUSELL_PRODUCTS']
  SIZE = 100
  def fetch_user_items(kk_id)
    uri = URI(format(ITEMS_API, kk_id, SIZE.to_s, ''))
    formate_items = []
    user_items = JSON.parse(Net::HTTP.get(uri), symbolize_names: true)
    formate_items  +=  parse_user_items(user_items) if user_items.present?

    while user_items[:has_more]
      uri = URI(format(ITEMS_API, kk_id, SIZE.to_s, user_items[:items].last[:serial_number]))
      user_items = user_items.merge(JSON.parse(Net::HTTP.get(uri), symbolize_names: true))
      formate_items += parse_user_items(user_items) if user_items.present?
    end

    formate_items
  end

  def upload_items(user_items, category_id)
    url = URI(CAROUSELL_PRODUCTS)
    check_validation = %i[name price].each do |column|
      return true if user_items[column].nil?
    end
    return if user_items.images.first.nil?
    return if check_validation == true

    upload_params = {
      title: user_items[:name],
      price: user_items[:price],
      collection_id: category_id
    }

    check_photo = %i[photo_0 photo_1 photo_2 photo_3].each_with_index do |photo, key|
      images = user_items.images.where(size: 'normal') || user_items.images.where(size: 'small')
      next unless images[key].present?
      puts 'Prepare images ' + images[key].to_s
      image = images[key]
      begin
        photo_file = File.new('kkmigrate/' + image[:filename])
      rescue
      end
      puts 'Image haven\'t download'
      return unless photo_file.present?
      upload_params[photo] = UploadIO.new(photo_file, 'image/jpeg', image[:filename])
    end

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = (url.scheme == 'https')
    response = http.start do |http|
      req = Net::HTTP::Post::Multipart.new(url, upload_params)
      return puts 'Token missing: ' + user_items.user.id.to_s if user_items.user.token.nil?
      puts 'Upload Product' + user_items.to_s + ' to ' + url.host
      key = 'Token ' + user_items.user.token
      req.add_field('Authorization', key) # add to Headers
      req.add_field('boundary', SecureRandom.uuid)
      http.request(req)
      user_items.update(is_uploaded: true)
    end
    
    puts 'Cateogry Name:' + user_items.category_lv2.to_s
    puts 'Response: ' + response.to_s
  end

  private

  def parse_user_items(user_items)
    items = user_items[:items].map do |item|
      {
        serial_number: item[:serial_number],
        category_lv1: item[:category].try(:[], :name),
        category_lv2: item[:category_lv2].try(:[], :name),
        price: item[:price],
        original_price: item[:original_price],
        name: item[:name],
        status: item[:status],
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
