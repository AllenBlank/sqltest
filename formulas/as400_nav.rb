module As400Nav

  def as400_nav_config
    load_script "auth"
    @locations = {}
  end

  def add_location name, commands
    @locations[name] = commands
  end

  def go_to location_name
    go_home
    return false unless home?
    commands = @locations[location_name]
    commands.each do |command|
      send command
    end
  end

  def home?
    screen_text.include? "APPLICATION PLUS - Main Menu"
  end
  
  def go_home
    connect unless connected?
    log_in unless logged_in?
    10.times do
      f3  unless home?
      f12 unless home?
      break if home?
    end
  end

end
