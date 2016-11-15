require 'login'
session 'as400.waxie.com' do
  login #login formula is invoked/run
  send_keys '1'
  enter
  send_keys '18'
  enter
  send_keys inputs[:order_number]
  enter
  print_screen
end
