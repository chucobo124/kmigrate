class Image < ApplicationRecord
  belongs_to :user_item
  enum size: %i[normal small]
  enum image_class: %i[cover_image images]
  scope :un_downloaded , -> { where(is_download: false) }
end
