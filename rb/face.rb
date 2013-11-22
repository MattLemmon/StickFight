class Eyes1
  def initialize parent
#    self.factor = 0.8
    @parent = parent
    @image = Gosu::Image["players/eye_sockets_2.png"]
    @eye_ball = Gosu::Image["players/eye_ball_2.png"]
    @eye_blink = Gosu::Image["players/eye_blink_2.png"]
    @x = 0
    @y = 0
    @blinking = false
    @blink_count = 0
    @blink_max = 8
    @rand = 8
    @eye_angle = 5
  end

  def update
    @x = @parent.x# + 1 * @parent.direction
    @y = @parent.y - 6
    puck = @parent.seek_opponent(@parent.game_state.peons2)# @parent.game_state.puck
    @eye_angle = Gosu.angle @x, @y, puck.x, puck.y
    if @blink_count < @blink_max
      @blink_count += 1
    else
      @blink_count = 0
      @blinking = false
      if rand(@rand) == 1
        @blinking = true
      end
    end
  end

  def draw
    @image.draw_rot @x, @y, Zorder::Face, 0, 0.5, 1.0
    @eye_ball.draw_rot @x-6+Gosu.offset_x(@eye_angle, 3), @y-1+Gosu.offset_y(@eye_angle, 2), Zorder::Face, 0, 0.5, 1.0
    @eye_ball.draw_rot @x+6+Gosu.offset_x(@eye_angle, 3), @y-1+Gosu.offset_y(@eye_angle, 2), Zorder::Face, 0, 0.5, 1.0
    if @blinking == true
      @eye_blink.draw_rot @x, @y, Zorder::Face, 0, 0.5, 1.0
    end
  end
end

class Eyes2
  def initialize parent
#    self.factor = 0.8
    @parent = parent
    @image = Gosu::Image["players/eye_sockets_2.png"]
    @eye_ball = Gosu::Image["players/eye_ball_2.png"]
    @eye_blink = Gosu::Image["players/eye_blink_2.png"]
    @x = 0
    @y = 0
    @blinking = false
    @blink_count = 0
    @blink_max = 8
    @rand = 8
    @eye_angle = 5
  end

  def update
    @x = @parent.x# + 1 * @parent.direction
    @y = @parent.y - 6
    puck = @parent.seek_opponent(@parent.game_state.peons1)# @parent.game_state.puck
    @eye_angle = Gosu.angle @x, @y, puck.x, puck.y
    if @blink_count < @blink_max
      @blink_count += 1
    else
      @blink_count = 0
      @blinking = false
      if rand(@rand) == 1
        @blinking = true
      end
    end
  end

  def draw
    @image.draw_rot @x, @y, Zorder::Face, 0, 0.5, 1.0
    @eye_ball.draw_rot @x-6+Gosu.offset_x(@eye_angle, 3), @y-1+Gosu.offset_y(@eye_angle, 2), Zorder::Face, 0, 0.5, 1.0
    @eye_ball.draw_rot @x+6+Gosu.offset_x(@eye_angle, 3), @y-1+Gosu.offset_y(@eye_angle, 2), Zorder::Face, 0, 0.5, 1.0
    if @blinking == true
      @eye_blink.draw_rot @x, @y, Zorder::Face, 0, 0.5, 1.0
    end
  end
end






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