module OrderInquiry

  def order_inquiry_config
    load "auth"
    load "as400 nav"
    add_location "order inquiry", ["1\r", "18\r"]
  end

  def order_inquiry order_number, company="01"
    go_to "order inquiry"
    3.times {tab}
    send company
    send order_number
    enter
  end

end
