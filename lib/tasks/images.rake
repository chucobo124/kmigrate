require 'image_kits/downloader.rb'
require 'logs/logs.rb'
namespace :images do
  desc 'Download images each by each'
  task download: :environment do
    proccess_name = 'ImageDownload'
    img_downloader = ImageKit::Downloader.new
    puts Logs::START_PROCESS % proccess_name
    Image.un_downloaded.each do |image|
      puts Logs::DOWNLOADING % image.filename
      img_downloader.download(image.uri, image.filename)

      # Update table Image
      puts format(Logs::UPDATE_TABLE, 'Image', image.filename)
      image.is_download = true
      image.save

      # Sleep
      puts Logs::SLEEP % 'one'
      sleep(1)
    end
    puts Logs::COMPLETED % proccess_name
  end
end
