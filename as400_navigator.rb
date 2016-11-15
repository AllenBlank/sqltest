# Blatantly ripped off of antimony gem.
# https://github.com/manheim/antimony 
# I needed something a touch lighter.


module Session_Settings

  ANSI_REGEX = /(\e\[.{1,2};?.{0,2}m|\e\[.{1}J|\e\[.{1,2}A|\e\[.{1,2}B|\e\[.{1,2}C|\e\[.{1,2}D|\e\[K|\e\[.{1,2};.{1,2}H|\e\[.{3}|.)/

  KEYBOARD_METHODS = {
    f1: "\x1B\x31".freeze,
    f2: "\x1B\x32".freeze,
    f3: "\x1B\x33".freeze,
    f4: "\x1B\x34".freeze,
    f5: "\x1B\x35".freeze,
    f6: "\x1B\x36".freeze,
    f7: "\x1B\x37".freeze,
    f8: "\x1B\x38".freeze,
    f9: "\x1B\x39".freeze,
    f10: "\x1B\x30".freeze,
    f11: "\x1B\x2D".freeze,
    f12: "\x1B\x3D".freeze,
    f13: "\x1B\x21".freeze,
    f14: "\x1B\x40".freeze,
    f15: "\x1B\x23".freeze,
    f16: "\x1B\x24".freeze,
    f17: "\x1B\x25".freeze,
    f18: "\x1B\x5E".freeze,
    f19: "\x1B\x26".freeze,
    f20: "\x1B\x2A".freeze,
    f21: "\x1B\x28".freeze,
    f22: "\x1B\x29".freeze,
    f23: "\x1B\x5F".freeze,
    f24: "\x1B\x2B".freeze,
    enter: "\n".freeze,
    tab: "\t".freeze,
    backspace: "\177".freeze,
    arrow_up: "\e[A".freeze,
    arrow_down: "\e[B".freeze,
    arrow_right: "\e[C".freeze,
    arrow_left: "\e[D".freeze
  }.freeze

  KEYBOARD_METHODS.each do |key, val|
    define_method(key) { send val }
  end

  SPACE = ' '.freeze
  EMPTY = ''.freeze

  ENTER = "\n".freeze
  TAB = "\t".freeze
  ESCAPE = "\e".freeze

  H = 'H'.freeze

  SEMICOLON = ';'.freeze

  LINE = /.{80}/

  def blank_screen
    (1..1920).to_a.map { |_i| SPACE }
  end

  def printable_screen_text
    @screen_text.join.scan LINE
  end
  
end

class Session
  
  attr_accessor :loud
  attr_reader :connection, :host 
  
  include Session_Settings 

  def initialize(host, username, password, loud=false)
    @host = host
    @loud = loud
     
    @connection = Net::Telnet::new("Host" => host, "Timeout" => 1)
    @screen_text = blank_screen
    
    @wait_options = { "Match" => /.{5}/, "Timeout" => 0.3}
    
    update_screen
    log_in username, password
  end

  def log_in username, password
    send username + "\t" + password + "\r"
  end

  def send(text)
    @connection.print text
    update_screen
  end
  
  def receive_data
    whole = []
    whole.push(@chunk) while chunk
    whole.join
  end

  def chunk
    @chunk = @connection.waitfor @wait_options
  rescue
  end

  def update_screen
    @screen_data = receive_data
    parse_ansi
    puts printable_screen_text if @loud
  end
 

  def value_at(row, column, length)
    start_index = ((row - 1) * 80) + (column - 1)
    end_index = start_index + length - 1
    @screen_text[start_index..end_index].join
  end

  def cursor_position(esc)
    esc_code = /\e\[/
    pos = esc.gsub(esc_code, EMPTY).gsub(H, EMPTY).split(SEMICOLON)
    row_index = pos[0].to_i - 1
    col_index = pos[1].to_i - 1
    (row_index * 80) + col_index
  end

  def parse_ansi

    @screen_text = blank_screen

    ansi = @screen_data.scan(ANSI_REGEX).map do |e|
      {
        value: e[0],
        type: e[0].include?(ESCAPE) ? :esc : :chr
      }
    end

    ansi.each do |e|
      if (e[:type] == :esc) && (e[:value].end_with? H)
        @cursor_position = cursor_position(e[:value])
      elsif e[:type] == :chr
        @screen_text[@cursor_position] = e[:value]
        @cursor_position += 1
      end
    end
    @screen_text
  end
  
  def screen_text
    @screen_text.join
  end

  def connected?
    !@connection.sock.closed?
  end

  def logged_in?
    send "\x03"
    status = @screen_text.include? "System Request"
    f12
    status
  end
  
end

module Farts
 def fart
   puts 'ffffbbbbttt.'
 end
end
 
