require 'image_kits/image_kit.rb'
require 'open-uri'
class ImageKit::Downloader < ImageKit
  PATH = ENV['IMAGE_PATH']
  def download(url, category, filename)
    category = PATH + '/' + category + '/'
    path = category + filename

    FileUtils.mkdir_p(category) unless File.directory?(category)
    open(path, 'wb') do |file|
      file << open(url).read
    end
  end
end
