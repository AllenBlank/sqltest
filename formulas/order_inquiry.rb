module OrderInquiry

  def order_inquiry_config
    load_script "auth"
    load_script "as400 nav"
    add_location "order inquiry", ["1\r", "18\r"]
  end

  def order_inquiry order_number, company="01"
    go_to "order inquiry"
    send "\t\t\t" + company + order_number + "\r" # go to the order selection screen
    status = value_at(5, 22, 8).strip
    ship_to = value_at(5, 57, 6).to_i
    
    send "1\r" # select the order and go to the first inquiry page
    run_number          = value_at(9 , 13, 8 ).to_i
    entry_date          = Date.strptime( value_at(12, 15, 8 ), "%m/%d/%y" )
    requested_ship_date = Date.strptime( value-at(13, 15, 8 ), "%m/%d/%y" )
    weight              = value_at(19, 59, 10).to_i
    cubes               = value_at(20, 59, 10).to_i
    
    send "\r" # go to the second inquiry page
    customer_number     = value_at(1 , 10, 49).split(" ","")[0]
    carrier             = value_at(14, 11, 6 ).strip
    
    send "\r" # go to the line items page

    # For each page of line items, add up the lines and and check for "waxie truck only" notes.
    until value_at(21, 76, 4) == "Last" do
      waxie_truck_only_strings.each do |string|
        danger = true if  screen_text.include? string
      end
      (5..20).each do |row| # for each line, if it's a line item, add it's shipped qty to total pieces shipped.
        if (1..99).include? value_at(row, 1, 2).to_i
          piece_count += value_at(row, 47, 7).to_i
        end 
      end
      send "\x1b[U" #page-down?
    end  
  end

end
