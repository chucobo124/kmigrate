require 'image_kits/downloader.rb'
require 'logs/logs.rb'
namespace :images do
  desc 'Download images each by each'
  task download: :environment do
    proccess_name = 'ImageDownload'
    loop do
      img_downloader = ImageKit::Downloader.new
      puts Logs::START_PROCESS % proccess_name
      Image.un_downloaded.each do |image|
        category = image.user_item.user.id.to_s + '/' + image.user_item.serial_number.to_s
        begin
          puts Logs::DOWNLOADING % image.filename
          img_downloader.download(image.uri, category, image.filename)
        rescue
        end
        # Update table Image
        puts format(Logs::UPDATE_TABLE, 'Image', image.filename)
        image.is_download = true
        image.save

        # Sleep
        puts Logs::SLEEP % 'one'
        sleep(1)
      end
      puts Logs::COMPLETED % 
    end
  end
end
