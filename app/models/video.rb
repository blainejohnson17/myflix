class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews

  validates_presence_of :title, :description

  def self.search_by_title(search_term)
    search_term.strip!
    search_term.blank? ? [] : \
    where("title LIKE ?", "%#{search_term}%").order("created_at DESC")
  end

  def average_rating
    if reviews.empty?
      return 0
    else
      average = 0  
      reviews.each { |review| average += review.rating }
      (average /= reviews.count.to_f).round(2)
    end
  end
end