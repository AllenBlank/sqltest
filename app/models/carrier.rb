class Carrier < ActiveRecord::Base
  serialize :orders, Hash
  def stop_count
    self.orders.count
  end
end
