class User < ActiveRecord::Base
  has_many :queue_items, order: 'position', dependent: :destroy
  has_many :reviews, order: 'created_at DESC', dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :full_name, presence: true
  validates :password, presence: true
  
  has_secure_password

  def normalize_queue_items_positions
    queue_items.each_with_index do |qi, index|
      qi.update_attributes(position: index + 1)
    end
  end

  def queued_video?(video)
    !queue_items.where(video_id: video.id).empty?
  end
end