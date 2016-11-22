module Auth

  def auth_config
  end

  def log_in
    username = ENV['as400_user']
    password = ENV['as400_pass']
    send username + "\t" + password + "\r"
    enter
  end

  def logged_in?
    send "\x03" #ctrl-c
    status = screen_text.include? "System Request"
    f12
    status
  end

end
