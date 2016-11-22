module OrderInquiry

  def order_inquiry_config
    load_script "auth"
    load_script "as400 nav"
    add_location "order inquiry", ["1\r", "18\r"]
  end

  def order_inquiry order_number, company="01"
    go_to "order inquiry"
    send "\t\t\t" + company + order_number + "\r" # go to the order selection screen
    return false if screen_text.include? "No records meet selection criteria."
    order = Order.new
    order.status = value_at(5, 22, 8).strip
    order.ship_to = value_at(5, 57, 6).to_i
    
    send "1\r" # select the order and go to the first inquiry page

    unless screen_text.include? "ORDER DISPLAY" # just forget it if it's invoiced already
      order.save
      return order
    end

    order.run                 = value_at(9 , 13, 8 ).to_i
    order.entry               = Date.strptime( value_at(12, 15, 8 ), "%m/%d/%y" )
    order.ship                = Date.strptime( value_at(13, 15, 8 ), "%m/%d/%y" )
    order.weight              = value_at(19, 59, 10).to_i
    order.cubes               = value_at(20, 59, 10).to_i
    
    send "\r" # go to the second inquiry page
    customer_unparsed   = value_at(1 , 10, 49).split(" ")[0].split("/")
    order.company             = customer_unparsed[0].to_i
    order.customer            = customer_unparsed[1].to_i
    order.carrier             = value_at(14, 11, 5 ).strip
    
    send "\r" # go to the line items page
    
    waxie_truck_only_strings = [
    "truck",
    "ups",
    "common",
    "cc21"
    ]
    # For each page of line items, add up the lines and and check for "waxie truck only" notes.
    count = 0
    order.pieces = 0 # set pieces to 0, this can be fixed later in modeling
 
    until( value_at(21, 76, 4) == "Last" || count == 10 ) do
      waxie_truck_only_strings.each do |string|
        order.danger = true if  screen_text.downcase.include? string
      end
      (5..20).each do |row| # for each line, if it's a line item, add it's shipped qty to total pieces shipped.
        unless value_at(row, 1, 4).blank?
          order.pieces += value_at(row, 47, 7).to_i
        end 
      end
      count = count + 1
      send "\x04" #page-down
    end
    
    order.save
    order  
  end

end
