class DownloadsController < ApplicationController
    def show
        send_file 'kkmigrate/csv_parser/'+ params[:id].to_s + '.csv', type: 'file/csv', disposition: 'inline'
    end

end
