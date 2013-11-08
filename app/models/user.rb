class User < ActiveRecord::Base
  has_secure_password

  attr_accessible :email, :full_name, :password

  validates :email, presence: true, uniqueness: true
  validates :full_name, presence: true
  validates :password, presence: true
end