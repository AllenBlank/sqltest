session 'as400.waxie.com' do
  send_keys "SEACB"
  tab
  send_keys "allen1"
  enter
  enter
  enter
  @outputs[:success] = screen_text.include? 'APPLICATION PLUS - Main Menu'
end
