class Category < ActiveRecord::Base
  has_many :categorizations, dependent: :destroy
  has_many :videos, through: :categorizations, order: :title

  validates :name, presence: :true
end