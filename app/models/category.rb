class Category < ActiveRecord::Base
  has_many :categorizations, dependent: :destroy
  has_many :videos, through: :categorizations, order: :title
end