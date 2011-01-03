require 'dl/import'
require 'auto_click/input_structure'
require 'auto_click/virtual_key'
require 'auto_click/user32'

module AutoClick
  
  @@rightdown = InputStructure.mouse_input(0,0,0,0x0008)
  @@rightup = InputStructure.mouse_input(0,0,0,0x0010)  
  @@leftdown = InputStructure.mouse_input(0,0,0,0x0002)
  @@leftup = InputStructure.mouse_input(0,0,0,0x0004)
    
  def send_input(inputs)
    n = inputs.size
    ptr = inputs.collect {|i| i.to_s}.join
    User32.SendInput(n, ptr, inputs[0].size)
  end

  def mouse_move(x,y)
    User32.SetCursorPos(x,y)
  end
  
  def mouse_move_pixel_absolute(x,y)
    User32.SetCursorPos(x,y)
  end
  
  def mouse_move_percentage_relative_virtual(x,y) # broken
    move = InputStructure.mouse_input(x,y,0,0x0001)
    send_input( [move])
  end
  
  def mouse_move_percentage_relative_real(x,y)  # broken
    move = InputStructure.mouse_input(x,y,0,0x4001)
    send_input( [move])
  end
  
  def mouse_move_percentage_absolute_virtual(x,y)
    move = InputStructure.mouse_input(x*65536,y*65536,0,0xc001)
    send_input( [move])
  end
  
  def mouse_move_percentage_absolute_real(x,y)
    move = InputStructure.mouse_input(x*65536,y*65536,0,0x8001)
    send_input( [move])
  end
    
  def right_click
    send_input( [@@rightdown, @@rightup] )
  end
  
  def left_click
    send_input( [@@leftdown, @@leftup] )
  end
  
  def cursor_position
    point = " " * 8
    User32.GetCursorPos(point)
    point.unpack('LL')  
  end
  
  def mouse_scroll(d) 
    scroll = InputStructure.mouse_input(0,0,d*120,0x0800)
    send_input( [scroll])
  end
  
  def left_drag(sx,sy,ex,ey)
    mouse_move sx,sy
    sleep 0.1
    send_input( [@@leftdown] )
    sleep 0.1
    mouse_move ex,ey
    sleep 0.1
    send_input( [@@leftup] )
    sleep 0.1
  end
  
  def right_drag(sx,sy,ex,ey)
    mouse_move sx,sy
    sleep 0.1
    send_input( [@@rightdown] )
    sleep 0.1
    mouse_move ex,ey
    sleep 0.1
    send_input( [@@rightup] )
    sleep 0.1
  end
  
  def key_stroke(key)
    code=VirtualKey.code_from_string(key)
    send_input([InputStructure.keyboard_input(code,0x0000),
                InputStructure.keyboard_input(code,0x0002)])
  end
  
  def key_down(key)
    code=VirtualKey.code_from_string(key)
    send_input([InputStructure.keyboard_input(code,0x0000)])
  end
  
  def key_up(key)
    code=VirtualKey.code_from_string(key)
    send_input([InputStructure.keyboard_input(code,0x0002)])
  end
  
  def type(string)
    puts string
  end

end


include AutoClick  # This line allow auto include when the user require the gem

  








