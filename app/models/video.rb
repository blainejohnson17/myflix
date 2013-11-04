class Video < ActiveRecord::Base
  has_many :categorizations, dependent: :destroy
  has_many :categories, through: :categorizations

  validates :title, :presence => true
  validates :description, :presence => true
end