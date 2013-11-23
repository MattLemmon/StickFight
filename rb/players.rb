DEBUG = false  # Set to true to see bounding circles used for collision detection

require_relative 'face'

#
#  PLAYER 1 CLASS
#
class Player1 < Chingu::GameObject
  traits :velocity, :collision_detection
  trait :bounding_box, :debug => DEBUG
  trait :timer
  attr_reader :direction, :mist, :selected, :health
#  attr_accessor :health, :attacking

  def initialize(options)
    super
    @image = Gosu::Image["players/#{$image1}.png"]
    cache_bounding_box
  end
  def setup
    self.factor = 0.7
    self.factor_x = -0.7
    @creeping = false
    @stun = false
    @mist = false
    @speed = $speed1
    @direction = -1
    @squeeze_y = 1.0
    @hit_time = Gosu.milliseconds - 3000
    @wobble_resistance = 0.008

    @health = $start_health1
    @eyes = Eyes1.new self
    @mouth = Mouth.new self
    @stick = Stick1.new(:x=>@x-20,:y=>@y,:zorder=>Zorder::Face)
    @health_bar = HealthBar.new self

    @selected = false
    @going = false
    @attacking = false
#    @last_x, @last_y = @x, @y
  end
  def build_farm
    Farm.create(:x=>@x, :y=>@y)
  end
  def build_rampart
    Rampart.create(:x=>@x, :y=>@y)
  end
  def select
    @selected_box = SelectedBox.create(:x=>@x,:y=>@y,:zorder=>10)
    @selected = true
  end
  def deselect
    if @selected_box != nil
      @selected_box.destroy
      @selected = false
    end
  end
  def going
    @going = true
    go_to_destination
  end
  def ungoing
    @going = false
  end
  def go_to_destination
    if @going == true
      if @selected == true
        if @x < $destination_x
          go_right
        end
        if @x > $destination_x
          go_left
        end
        if @y < $destination_y
          go_down
        end
        if @y > $destination_y
          go_up
        end
        after(10) {
          if @x - $destination_x < 10 && @x - $destination_x > -10 && @y - $destination_y < 10 && @y - $destination_y > -10
            puts "arrived at destination"
            @going = false
          else
            go_to_destination
          end
        }
      end
    end
  end
  def preattack
    @attacking = true
  end
  def attack(opponent)
    if @attacking == true
#      if rand(10) == 1
#      puts "attack"
      wiggle_stick
      opponent.damage
#      end
    end
  end
  def unattack
    @attacking = false
  end

  def seek_opponent(opponents)
    closest = opponents.first
    dist = distance(closest.x, closest.y, @x, @y)
    opponents.each do |tar|
      new_dist = distance(tar.x, tar.y, @x, @y)
      if new_dist < dist
        closest = tar
        dist = new_dist
      end
    end
    return closest
  end

  def go_left;    @velocity_x = -@speed;  end
  def go_right;   @velocity_x = @speed;   end
  def go_up;      @velocity_y = -@speed;  end
  def go_down;    @velocity_y = @speed;   end

  def hit_wobble_factor
    time = Gosu.milliseconds - @hit_time
    1 - (Math.sin(time/25.0)/(time**1.7*@wobble_resistance))
  end
  def wobble
    @hit_time = Gosu.milliseconds - 30
  end

  def damage
#    puts "damage"
    @health -= 1
    wobble
  end
  def update_health_bar
    @health_bar.update
  end
  def update_face
    @eyes.update
    @mouth.update
  end
  def update_box
    if @selected_box != nil
      @selected_box.x = @x
      @selected_box.y = @y
    end
  end
  def update_stick
    @stick.x = @x - 20
    @stick.y = @y
    @stick.update
  end
  def wiggle_stick
    @stick.wiggle
    after(160){@stick.unwiggle}
  end
  def update
    self.factor_y *= @squeeze_y
    self.factor_x = 0.7 * hit_wobble_factor * @direction
    @squeeze_y = 1.0
    if @stun == true
      @speed = 0
    else
      @speed = $speed1
    end

    @velocity_x *= 0.25
    @velocity_y *= 0.25
    update_face
    update_box
    update_stick
    update_health_bar

    if @x < -$scr_edge; @x = -$scr_edge; end
    if @y < -$scr_edge; @y = -$scr_edge; end
    if @x > $max_x; @x = $max_x; end
    if @y > $max_y; @y = $max_y; end
#    @last_x, @last_y = @x, @y

  end

  def draw
    if @mist == false
      super
      @eyes.draw
      @mouth.draw
      @stick.draw
      @health_bar.draw
    end
  end
end


#
#  PLAYER 2 CLASS
#
class Player2 < Chingu::GameObject
  traits :velocity, :collision_detection
  trait :bounding_box, :debug => DEBUG
  trait :timer
  attr_reader :direction, :mist, :selected, :health

  def initialize(options)
    super
    @image = Gosu::Image["players/#{$image2}.png"]
    @direction = 1
    cache_bounding_box
  end
  def setup
    self.factor = 0.7
    @creeping = false
    @stun = false
    @mist = false
    @speed = $speed2
    @direction = 1
    @squeeze_y = 1.0
    @hit_time = Gosu.milliseconds - 3000
    @wobble_resistance = 0.008
    @eyes = Eyes2.new self
    @mouth = Mouth.new self
    @health_bar = HealthBar.new self
    @stick = Stick2.new(:x=>@x-20,:y=>@y,:zorder=>Zorder::Face)

    @health = $start_health2
    @selected = false
  end
  def build_farm
    Farm.create(:x=>@x, :y=>@y)
  end
  def build_rampart
    Rampart.create(:x=>@x, :y=>@y)
  end
  def select
    @selected_box = SelectedBox.create(:x=>@x,:y=>@y,:zorder=>10)
    @selected = true
  end
  def deselect
    if @selected_box != nil
      @selected_box.destroy
      @selected = false
    end
  end
  def going
    @going = true
    go_to_destination
  end
  def ungoing
    @going = false
  end
  def go_to_destination
    if @going == true
      if @selected == true
        if @x < $destination_x
          go_right
        end
        if @x > $destination_x
          go_left
        end
        if @y < $destination_y
          go_down
        end
        if @y > $destination_y
          go_up
        end
        after(10) {
          if @x - $destination_x < 10 && @x - $destination_x > -10 && @y - $destination_y < 10 && @y - $destination_y > -10
            puts "arrived at destination"
            @going = false
          else
            go_to_destination
          end
        }
      end
    end
  end

  def walk_wobble_factor  #sin curve between 1..0.8 at 5hz
    1 - (Math.sin(Gosu.milliseconds/(Math::PI*10))+1)/10.0
  end
  def hit_wobble_factor
    time = Gosu.milliseconds - @hit_time
    1 - (Math.sin(time/25.0)/(time**1.7*@wobble_resistance))
  end
  def wobble
    @hit_time = Gosu.milliseconds - 30
  end

  def attack(opponent)
    wiggle_stick
    opponent.damage
  end

  def seek_opponent(opponents)
    closest = opponents.first
    dist = distance(closest.x, closest.y, @x, @y)
    opponents.each do |tar|
      new_dist = distance(tar.x, tar.y, @x, @y)
      if new_dist < dist
        closest = tar
        dist = new_dist
      end
    end
    return closest
  end

  def go_left;    @velocity_x = -@speed;  end
  def go_right;    @velocity_x = @speed;  end
  def go_up;    @velocity_y = -@speed;  end
  def go_down;    @velocity_y = @speed;  end

  def damage
#    puts "damage"
    @health -= 1
    wobble
  end

  def update_health_bar
    @health_bar.update
  end
  def update_face
    @eyes.update
    @mouth.update
  end
  def update_box
    if @selected_box != nil
      @selected_box.x = @x
      @selected_box.y = @y
    end
  end
  def update_stick
    @stick.x = @x + 20
    @stick.y = @y
    @stick.update
  end
  def wiggle_stick
    @stick.wiggle
    after(160){@stick.unwiggle}
  end

  def update
    self.factor_y *= @squeeze_y
    self.factor_x = 0.7 * hit_wobble_factor * @direction
    @squeeze_y = 1.0
    if @stun == true
      @speed = 0
    elsif @creeping == true
      @speed = 5
    else
      @speed = $speed2
    end
    @creeping = false
    @velocity_x *= 0.25
    @velocity_y *= 0.25
    update_face
    update_stick
    update_box
    update_health_bar

    if @x < -$scr_edge; @x = -$scr_edge; end
    if @y < -$scr_edge; @y = -$scr_edge; end
    if @x > $max_x; @x = $max_x; end
    if @y > $max_y; @y = $max_y; end
#    @last_x, @last_y = @x, @y
  end

  def draw
    if @mist == false
      super
      @eyes.draw
      @mouth.draw
      @stick.draw
      @health_bar.draw
    end
  end
end


