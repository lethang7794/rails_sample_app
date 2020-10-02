class Micropost < ApplicationRecord
  belongs_to :user
  
  acts_as_commontable
  acts_as_votable

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
        "<a href='/#{user.username}'>#{match}</a>"
      else
        match
      end
    }
  end

  # Returns url for resized image without transparency.
  def image_url
    variant = image.variant(resize_to_limit: [500, 500], background: "white", alpha: "remove")
    Rails.application.routes.url_helpers.rails_representation_url(variant.processed, only_path: true)
  end

  # Returns RGBA color values of dominant color of micropost's image.
  def image_dominant_color(alpha = 0.9)
    image = MiniMagick::Image.open(self.image)
    image.resize("1x1")
    red, blue, green = image.get_pixels[0][0]
    "rgba(#{red}, #{blue}, #{green}, #{alpha})"
  end
end
