load 'as400_navigator.rb'
s = Session.new 'as400.waxie.com', true
s.load_script('order inquiry')
s.log_in
s.order_inquiry "B65E3"