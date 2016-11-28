class Customer < ActiveRecord::Base
  has_many :shiptos
  has_many :orders, through: :shiptos
end
