class Review < ActiveRecord::Base
  belongs_to :video
  belongs_to :user

  validates_presence_of :content
  validates_uniqueness_of :video_id, scope: :user_id
  validates_numericality_of :rating, only_integer: :true
end