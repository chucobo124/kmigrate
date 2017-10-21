class User < ApplicationRecord
    has_one :status , dependent: :destroy
    has_one :user_profile , dependent: :destroy
    has_many :user_items, dependent: :destroy
end
