module As400Values

  def as400_values_config
    @date_format = "%m%d%y"
  end

  def format_date date
    date.strftime @date_format
  end

  def today
    format_date Date.today
  end

  def next_ship_day
    if Date.today.wday == 5
      return format_date( Date.today + 3.days )
    else
      return format_date( Date.today + 1.days )
    end
  end

end