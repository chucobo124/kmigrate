class Status < ApplicationRecord
  belongs_to :user
  scope :un_profile, -> { where(is_profile: false) }
  scope :un_profile_details, -> { where(is_profile_detail: false) }
  scope :un_user_items, -> { where(is_user_item: false) }
end
