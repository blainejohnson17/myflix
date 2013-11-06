class Video < ActiveRecord::Base
  has_many :categorizations, dependent: :destroy
  has_many :categories, through: :categorizations, order: :name

  validates_presence_of :title, :description
end