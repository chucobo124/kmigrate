require 'image_kits/image_kit.rb'
require 'open-uri'
class ImageKit::Downloader < ImageKit
  PATH = ENV['IMAGE_PATH']
  def download(url, filename)
    open(PATH + filename, 'wb') do |file|
      file << open(url).read
    end
  end
end
