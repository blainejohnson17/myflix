class QueueItem < ActiveRecord::Base
  validates_uniqueness_of :video_id, scope: :user_id
  validates_numericality_of :position, only_integer: :true

  belongs_to :user
  belongs_to :video

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video

  def rating
    review = Review.where(video_id: video.id, user_id: user.id).first
    review.rating if review
  end

  def rating=(new_rating)
    review = Review.where(user_id: user.id, video_id: video.id).first
    if review
      new_rating == "0" ? review.destroy : review.update_attributes(rating: new_rating)
    else
      return if new_rating == "0"
      review = Review.new(user: user, video: video, rating: new_rating)
      review.save(validate: false)
    end
  end

  def category_name
    category.name
  end
end