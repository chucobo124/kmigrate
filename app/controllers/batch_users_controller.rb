class BatchUsersController < ApplicationController
  require 'csv'
  require 'net/http'
  CONNECTION_RETRY = 5
  def index; end

  def show; end

  def create
    if users.present?
      users.each do |user|
        user = User.find_or_create_by(user)
        user.status= Status.create
      end
    end
    redirect_to users_path
  end

  def upload_token_with_csv
    csv = CSV.parse(csv_file.open.read)
    users = csv.map do |row|
      carousell_user = row[0]
      token = row[1]
      user = User.find_by(carousell_user: carousell_user)
      if user.present?
        user.update(token: token)
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
      if user.present?
        user[:serial_number] = serial_number
        user[:carousell_user] = carousell_user
      end
      user
    end.compact

    csv_string = CSV.generate do |csv|
      csv << users[0].keys
      users.each { |user| csv << user.values }
    end

    if csv_string.present?
      path = 'kkmigrate/csv_parser/check_result_' + Time.now.strftime('%y%m%d_%H_%M_%S')
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
      user_checking = user_checking(serial_number, carousell_user)
      if user_checking[:is_kktown_user] && user_checking[:is_carousell_user]
        user_profile << { serial_number: serial_number,
                          carousell_user:  carousell_user }
      end
    end
    user_profile
  end

  def user_checking(serial_number, carousell_user)
    is_carousell_user = false
    is_kktown_user = false

    begin
      caro_uri = URI.parse((USERNAME_PROFILE % carousell_user.to_s))
    rescue
    end

    if caro_uri.present?
      resp = Net::HTTP.get_response(caro_uri)
      retry_count = 0
      while (resp.code == '301' || resp.code == '302') && (retry_count < CONNECTION_RETRY)
        if resp.header['location'].present?
          resp = Net::HTTP.get_response(URI.parse(resp.header['location']))
        end
        next unless resp.body.present?
        carousell_user = JSON.parse(resp.body, symbolize_names: true)
      end

      if carousell_user.present?
        if !carousell_user[:is_admin].nil?
          is_carousell_user = !carousell_user[:is_admin]
        else
          is_carousell_user = carousell_user[:is_admin]
        end
      end
    end

    begin
      kk_uri = URI.parse((PROFILE_API % serial_number.to_s))
    rescue
    end

    if kk_uri.present?
      resp = JSON.parse(Net::HTTP.get_response(kk_uri).body, symbolize_names: true)
      is_kktown_user = true if resp[:serial_number] == serial_number
    end

    { is_kktown_user: is_kktown_user,
      is_carousell_user: is_carousell_user }
  end
end
