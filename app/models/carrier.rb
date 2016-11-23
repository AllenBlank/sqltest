class Carrier < ActiveRecord::Base
  serialize :orders, Hash
end
