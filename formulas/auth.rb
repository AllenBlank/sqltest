module Auth

  def auth_config
  end

  def log_in username, password
    send username + "\t" + password + "\r"
  end

  def logged_in?
    send "\x03"
    status = @screen_text.include? "System Request"
    f12
    status
  end

end
