class User < ActiveRecord::Base
  has_secure_password

  attr_accessible :email, :full_name, :password

  validates :email, presence: true, uniqueness: true
  validates :full_name, presence: true
  validates :password, presence: true
  
  has_many :queue_items, order: 'position'

  def normalize_queue_items_positions
    queue_items.each_with_index do |qi, index|
      qi.update_attributes(position: index + 1)
    end
  end
end