class Mouth
  attr_accessor :scale_y, :mood
  
  def initialize parent
    @parent = parent
    @image = Gosu::Image["players/mouth_2.png"]
    @mouth_closed = Gosu::Image["players/mouth_closed_2.png"]
    @x = 0
    @y = 0
    @mood = 0
    @scale_y = 0
  end
  
  def update
    @x = @parent.x + 1 * @parent.direction
    @y = @parent.y - 2
#    if @parent.health > -2
#      @mood = @parent.health/10
#    else
#      @mood = -0.2
#    end
    @scale_y = -2.3 + @parent.health / 3.0
#    += (@mood-@scale_y)*0.1
  end
  
  def draw
    @mouth_closed.draw_rot @x, @y, Zorder::Face, 0, 0.5, 0.5, 1
    @image.draw_rot @x, @y, Zorder::Face, 0, 0.5, 0.5, 1, @scale_y
  end
end


class Mouth2
  attr_accessor :scale_y, :mood
  
  def initialize parent
    @parent = parent
    @image = Gosu::Image["players/mouth_2.png"]
    @mouth_closed = Gosu::Image["players/mouth_closed_2.png"]
    @x = 0
    @y = 0
    @mood = 0
    @scale_y = 0
  end
  
  def update
    @x = @parent.x + 1 * @parent.direction
    @y = @parent.y - 2
    puck = @parent.game_state.puck
    case @parent.direction
    when -1
      if puck.x > @x-60
        @mood = -1
      elsif puck.x < 150
        @mood = 1
      else
        @mood = 0.3
      end
    when 1
      if puck.x < @x+60
        @mood = -1
      elsif puck.x > $window.width-150
        @mood = 1
      else
        @mood = 0.3
      end
    end
    @scale_y += (@mood-@scale_y)*0.1
  end
  
  def draw
    @mouth_closed.draw_rot @x, @y, Zorder::Face, 0, 0.5, 0.5, 1
    @image.draw_rot @x, @y, Zorder::Face, 0, 0.5, 0.5, 1, @scale_y
  end
end