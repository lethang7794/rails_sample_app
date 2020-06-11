class Micropost < ApplicationRecord
  belongs_to :user

  has_one_attached :image

  default_scope -> { order(created_at: :desc) }

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }

  validates :image, content_type:
                            { in: %w[image/png image/jpeg image/gif], message: 'should be png/jpeg/gif.' },
                    size: { less_than: 3.megabytes, message: 'should be less than 3MB.' }

  # Returns a resized image for display.
  def display_image
    image.variant(resize_to_limit: [500, 500])
  end

  # Returns url for resized image.
  def image_url
    Rails.application.routes.url_helpers.rails_representation_url(image.variant(resize_to_limit: [500, 500]).processed, only_path: true)
  end
end
