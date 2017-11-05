require 'kktown/kapi.rb'
require 'net/http'

class KAPI::UserItems < KAPI
  ITEMS_API = ENV['ITEMS_API']
  CREATE_PRODUCT_API = ENV['CREATE_PRODUCT_API']
  SIZE = 100
  def fetch_user_items(kk_id)
    uri = URI(format(ITEMS_API, kk_id, SIZE.to_s))
    user_items = JSON.parse(Net::HTTP.get(uri), symbolize_names: true)
    parse_user_items(user_items)
  end

  def upload_items(_item)
    # uri = URI(CREATE_PRODUCT_API)
    # header = {
    #   'Authorization' => 'Token 649cc2badf31e518a6de8f9eca8b1e8d402fd076',
    #   'Content-Type' => 'application/x-www-form-urlencoded'
    # }
    # http = Net::HTTP.new(uri.host, uri.port)
    # http.use_ssl = true
    # # path(a.k.a) ->www.mysite.com/some_POST_handling_script.rb'
    # path = '/api/2.5/products/'
    # encode_post_form = URI.encode_www_form(post_form)
    # resp, data = http.post(path, encode_post_form, header)
    # puts 'Code = ' + resp.code
    # puts 'Message = ' + resp.message
    # resp.each { |key, val| puts key + ' = ' + val }
    # puts data
    #     require 'uri'
    #     require 'net/http'
    #     require 'open-uri'
    url = URI('https://stage3.carousell.io/api/2.0/products/')
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(url)
    image_link = 'https://media.karousell.com/media/photos/products/2017/10/06/124738_48925_thumbnail.jpg'
    request['authorization'] = 'Token 649cc2badf31e518a6de8f9eca8b1e8d402fd076'
    request['content-type'] = 'application/x-www-form-urlencoded'
    body = { title: 'test_file', price: 1000, photo_0: open('kkimages/test.png').read, collection_id: 255 }
    request.body = URI.encode_www_form(body)
    response = http.request(request)
    puts response.read_body
  end

  private

  def create_upload_item_post_form
    test_image_uri = 'https://www.blog.google/static/blog/images/google-200x200.7714256da16f.png'
    photo_0 = open(test_image_uri).read
    {
      title: 'test_file',
      price: 1000,
      description: 'test_description',
      photo_0: photo_0,
      collection_id: 255
    }
  end

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
end
