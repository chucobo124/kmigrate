class UserItem < ApplicationRecord
    has_many :images
    belongs_to :user
    scope :un_uploaded , -> { where(is_uploaded: false) }
end
