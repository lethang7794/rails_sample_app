class Micropost < ApplicationRecord
  belongs_to :user

  has_one_attached :image

  default_scope -> { order(created_at: :desc) }

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }

  validates :image, content_type:
                            { in: %w[image/png image/jpeg image/gif], message: 'should be png/jpeg/gif.' },
                    size: { less_than: 3.megabytes, message: 'should be less than 3MB.' }

end
