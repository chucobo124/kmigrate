class BatchUsersController < ApplicationController
  require 'csv'
  def create
    if users.present?
      users.each do |user|
        User.find_or_create_by(user)
      end
    end
    redirect_to users_path
  end

  def user_checking(serial_number, carousell_user)
    uri = URI.parse(USERNAME_PROFILE % carousell_user)
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

    uri = URI.parse(PROFILE_API % serial_number)
    resp = JSON.parse(Net::HTTP.get_response(uri).body, symbolize_names: true)
    is_kktown_user = true if resp[:serial_number] == serial_number

    is_kktown_user && is_carousell_user
  end

  private

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
end
