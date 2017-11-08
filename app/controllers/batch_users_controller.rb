class BatchUsersController < ApplicationController
  require 'csv'
  include ActionController::DataStreaming
  def index; end

  def show; end

  def create
    if users.present?
      users.each do |user|
        User.find_or_create_by(user)
      end
    end
    redirect_to users_path
  end

  def checking_with_csv
    csv = CSV.parse(csv_file.open.read)
    users = csv.drop(1).map do |row|
      carousell_user = row[2]
      serial_number = row[1]
      user = user_checking(serial_number, carousell_user)
      user[:serial_number] = serial_number
      user[:carousell_user] = carousell_user
      user
    end

    csv_string = CSV.generate do |csv|
      csv << users[0].keys
      users.each { |user| csv << user.values }
    end

    if csv_string.present?
      path = 'kkmigrate/csv_parser/check_result_' + Time.now.strftime("%y%m%d_%H_%M_%S")
      File.open(path + '.csv', 'w+') do |f|
        f.write(csv_string)
      end
    end
    redirect_to batch_users_path
  end

  private

  def csv_file
    params.require(:csv_file)
  end

  def users
    user_csv = params.require(:users)
    user_profile = []
    CSV.parse(user_csv.open.read).drop(1).each do |row|
      serial_number = row[1]
      carousell_user = row[2]
      if user_checking(serial_number, carousell_user)
        user_profile << { serial_number: serial_number,
                          carousell_user:  carousell_user }
      end
    end
    user_profile
  end

  def user_checking(serial_number, carousell_user)
    uri = URI.parse((USERNAME_PROFILE % carousell_user).delete(' '))
    is_carousell_user = false
    is_kktown_user = false
    resp = Net::HTTP.get_response(uri)
    if resp.code == '301'
      resp = Net::HTTP.get_response(URI.parse(resp.header['location']))
      if resp.code == '302'
        carousell_user = JSON.parse(Net::HTTP.get_response(URI.parse(resp.header['location'])).body, symbolize_names: true)
        if carousell_user.present?
          is_carousell_user = carousell_user[:is_admin].present? && !carousell_user[:is_admin]
        end
      end
    end

    uri = URI.parse((PROFILE_API % serial_number).delete(' '))
    resp = JSON.parse(Net::HTTP.get_response(uri).body, symbolize_names: true)
    is_kktown_user = true if resp[:serial_number] == serial_number

    { is_kktown_user: is_kktown_user,
      is_carousell_user: is_carousell_user }
  end
end
