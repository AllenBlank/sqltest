module CarrierInquiry

  def carrier_inquiry_config
    load_script "auth"
    load_script "as400 nav"
    load_script "as400 values"
    add_location "carrier inquiry", ["1\r", "17\r"]
  end

  def carrier_inquiry( name, company="01", date=next_ship_day )
    go_to "carrier inquiry"
    send "\t\t\t" + company + name + "\r"
    send "YYYDH\t\tNNN\t\t" + date + date
    f6

    return false unless screen_text.include? "CARRIER STOP"

    carrier        = Carrier.new
    carrier.date   = Date.strptime( date , "%m%d%y" )    
    carrier.name   = name
    carrier.cubes  = value_at(1 , 69, 6).gsub(",","").to_i
    carrier.weight = value_at(2 , 69, 6).gsub(",","").to_i
    carrier.value  = value_at(3 , 69, 6).gsub(",","").to_i
    
    carrier.orders = {}
    carrier.order_count = 0
    more = "+"
    until more.blank?
      more = value_at(19, 79, 1)
      (5..19).each do |row|
        unless value_at(row, 3, 3).blank?
          order_number = value_at(row, 31, 8)
          stop         = value_at(row, 18, 3).to_i
          carrier.orders[stop] = [] if carrier.orders[stop].nil?
          carrier.orders[stop] << order_number
          carrier.order_count  = carrier.order_count + 1
        end
      end
      send "\x04" # page down
      refresh
    end
    carrier.save
    carrier
  end 
end