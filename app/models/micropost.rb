class Micropost < ApplicationRecord
  belongs_to :user

  has_one_attached :image

  default_scope -> { order(created_at: :desc) }

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 280 }

  validates :image, content_type:
                            { in: %w[image/png image/jpeg image/gif], message: 'should be png/jpeg/gif.' },
                    size: { less_than: 3.megabytes, message: 'should be less than 3MB.' }

  # Returns a resized image for display.
  def display_image
    image.variant(resize_to_limit: [500, 500])
  end

	# Replace words in content begin with # by hyperlink, @ by link to user profile page if the user exists
  def content_display
    content.gsub!(/(?<hash>#\S+)/, '<a href="#">\k<hash></a>')

    content.gsub(/@(?<username>\S+)/) { |match|
      # debugger
      if user = User.find_by("lower(username) = ?", $1.downcase)
        "<a href='#{user.username}'>#{match}</a>"
      else
        match
      end
    }
  end

  # Returns url for resized image.
  def image_url
    Rails.application.routes.url_helpers.rails_representation_url(image.variant(resize_to_limit: [500, 500]).processed, only_path: true)
  end
end
