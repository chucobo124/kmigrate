require 'image_kits/image_kit.rb'
require 'open-uri'
class ImageKit::Downloader < ImageKit
  PATH = ENV['IMAGE_PATH']
  def download(_url, filename)
    open(PATH + filename, 'wb') do |file|
      test_path= 'https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png'
      file << open(test_path).read
    end
  end
end
