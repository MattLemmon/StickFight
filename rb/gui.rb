class MiniMapGenerator
  attr_reader :image
  def initialize(area, enemies, ship)
    #area = [play area width, play area height]
    #objects = [Planets, Stars]
    @area    = area
#    @planets = planets
    @enemies = enemies
    @ship    = ship
    @image   = TexPlay.create_image($window, area[0]/100, area[1]/100)#, caching: false)
    generate_image
    return @image
  end

  def generate_image
#    @planets.each do |planet|
#      if planet.habitable
#        @image.pixel(planet.x/100, planet.y/100, color: :blue) if planet.base.nil?
#        @image.pixel(planet.x/100, planet.y/100, color: :cyan) unless planet.base.nil?
#      else
#        @image.pixel(planet.x/100, planet.y/100, color: :yellow)
#      end
#    end
    @enemies.each do |enemy|
      @image.pixel(enemy.x/100, enemy.y/100, color: :red)
    end
    @ship.each do |ship|
      @image.pixel(ship.x/100, ship.y/100, color: :green)
    end
  end
end

class MiniMap < Chingu::GameObject
  def setup
    @tick = 0
    self.x = $window.width-(30*5)
    self.y = 100
    self.zorder = 999
#    @ship = Ship.all.first
    # MiniMapGenerator.new([3000,3000], Planet.all, @ship)
  end

  def update
    self.factor = 5
    if @tick >= 10
      map = MiniMapGenerator.new([3000,3000], Player2.all, Player1.all)
      self.image = map.image.retrofy
      @tick = 0
    end
    @tick+=1
  end
end


#
# HEALTH BAR
#
class HealthBar
  def initialize parent
    @parent = parent
    @health_bar = Image["gui/health_bar.png"]
    @health_red = Image["gui/health_red.png"]
    @health_green = Image["gui/health_green.png"]
  end
  def update
    @x = @parent.x
    @y = @parent.y + 30
  end

  def draw
    @health_bar.draw(@x, @y, Zorder::GUI_Bkgrd)
    if @parent.health > 4
      for i in 1..@parent.health
        @health_green.draw(@x-12+2*i, @y, Zorder::GUI)
      end
    else
      for i in 1..@parent.health
        @health_red.draw(@x-12+2*i, @y, Zorder::GUI)
      end
    end
  end
end


#
#  GUI1 CLASS             ( RIGHT PLAYER )
#    Health Meter, Star Meter
class GUI1 < Chingu::GameObject
  def initialize
	  super
	  @heart_meter = Gosu::Image.new($window, "./media/gui/heart_meter.png")
    @score_box = Gosu::Image.new($window, "./media/gui/score_box.png")
	  @star_full = Gosu::Image.new($window, "./media/gui/star_full.png")
	  @star_empty = Gosu::Image.new($window, "./media/gui/star_empty.png")
    @spell_empty = Gosu::Image.new($window, "./media/gui/spell_empty.png")
    @stun = Gosu::Image.new($window, "./media/gui/stun.png")
    @mist = Gosu::Image.new($window, "./media/gui/mist.png")

    @text_pos_x = 684

    @power_ups_text1 = Chingu::Text.create("", :y => 42, :font => "GeosansLight", :size => 26, :zorder => Zorder::GUI)
    @power_ups_text1.x = @text_pos_x - @power_ups_text1.width/2

    @power_ups_text2 = Chingu::Text.create("", :y => 63, :font => "GeosansLight", :size => 26, :zorder => Zorder::GUI)
    @power_ups_text2.x = @text_pos_x - @power_ups_text2.width/2

    @power_ups_text3 = Chingu::Text.create("", :y => 86, :font => "GeosansLight", :size => 26, :zorder => Zorder::GUI)
    @power_ups_text3.x = @text_pos_x - @power_ups_text3.width/2

    if $power_ups1 > 0
      @power_ups_text1.text = "Speed"
      @power_ups_text1.x = @text_pos_x - @power_ups_text1.width/2
    end
    if $power_ups1 > 1
      @power_ups_text2.text = "Bump"
      @power_ups_text2.x = @text_pos_x - @power_ups_text2.width/2
    end
    if $power_ups1 > 2
      @power_ups_text3.text = "Kick"
      @power_ups_text3.x = @text_pos_x - @power_ups_text3.width/2
    end
  end

  def power_up
    if $power_ups1 == 1
      @power_ups_text1.text = "Speed"
      @power_ups_text1.x = @text_pos_x - @power_ups_text1.width/2
    elsif $power_ups1 == 2
      @power_ups_text2.text = "Bump"
      @power_ups_text2.x = @text_pos_x - @power_ups_text2.width/2
    else
      @power_ups_text3.text = "Kick"
      @power_ups_text3.x = @text_pos_x - @power_ups_text3.width/2
    end
  end

#  def update
#    super
#    @timer_text.text = "Timer: #{milliseconds % 30}"
#    @timer_text.x = @x + @timer_pos_x - @timer_text.width/2
#    @timer_text.y = @y + @timer_pos_y
#  end

  def draw
    @heart_meter.draw(@x+738, @y+4, 10)
    @score_box.draw(@x+473, @y+4, 10)

    for i in 1..5
      @star_empty.draw(@x+730-22*i, @y+15, Zorder::GUI_Bkgrd)
    end
    for i in 1..$stars1
      @star_full.draw(@x+730-22*i, @y+15, Zorder::GUI)
    end

    @spell_empty.draw(@x+593, @y+15, Zorder::GUI_Bkgrd)
    if $spell1 == "stun"
      @stun.draw(@x+593, @y+15, Zorder::GUI)
    end
    if $spell1 == "mist"
      @mist.draw(@x+593, @y+15, Zorder::GUI)
    end
	end
end


#
#  GUI2 CLASS             ( LEFT PLAYER )
#    Health Meter, Star Meter
class GUI2 < Chingu::GameObject
  def initialize
	  super
	  @heart_meter = Gosu::Image.new($window, "./media/gui/heart_meter.png")
    @score_box = Gosu::Image.new($window, "./media/gui/score_box.png")
	  @star_full = Gosu::Image.new($window, "./media/gui/star_full.png")
	  @star_empty = Gosu::Image.new($window, "./media/gui/star_empty.png")
    @spell_empty = Gosu::Image.new($window, "./media/gui/spell_empty.png")
    @stun = Gosu::Image.new($window, "./media/gui/stun.png")
    @mist = Gosu::Image.new($window, "./media/gui/mist.png")

#    @power_ups_text = Chingu::Text.create("Power Ups: #{$power_ups2}", :y => 50, :font => "GeosansLight", :size => 26, :zorder => Zorder::GUI)
#    @power_ups_text.x = 110 - @power_ups_text.width/2

    @text_pos_x = 116

    @power_ups_text1 = Chingu::Text.create("", :y => 42, :font => "GeosansLight", :size => 26, :zorder => Zorder::GUI)
    @power_ups_text1.x = @text_pos_x - @power_ups_text1.width/2

    @power_ups_text2 = Chingu::Text.create("", :y => 63, :font => "GeosansLight", :size => 26, :zorder => Zorder::GUI)
    @power_ups_text2.x = @text_pos_x - @power_ups_text2.width/2

    @power_ups_text3 = Chingu::Text.create("", :y => 86, :font => "GeosansLight", :size => 26, :zorder => Zorder::GUI)
    @power_ups_text3.x = @text_pos_x - @power_ups_text3.width/2

    if $power_ups2 > 0
      @power_ups_text1.text = "Speed"
      @power_ups_text1.x = @text_pos_x - @power_ups_text1.width/2
    end
    if $power_ups2 > 1
      @power_ups_text2.text = "Bump"
      @power_ups_text2.x = @text_pos_x - @power_ups_text2.width/2
    end
    if $power_ups2 > 2
      @power_ups_text3.text = "Kick"
      @power_ups_text3.x = @text_pos_x - @power_ups_text3.width/2
    end
  end

  def power_up
    if $power_ups2 == 1
      @power_ups_text1.text = "Speed"
      @power_ups_text1.x = @text_pos_x - @power_ups_text1.width/2
    elsif $power_ups2 == 2
      @power_ups_text2.text = "Bump"
      @power_ups_text2.x = @text_pos_x - @power_ups_text2.width/2
    else
      @power_ups_text3.text = "Kick"
      @power_ups_text3.x = @text_pos_x - @power_ups_text3.width/2
    end
  end

  def draw
    @heart_meter.draw(@x + 10, @y + 4, 10)
    @score_box.draw(@x+273, @y+4, 10)

    for i in 1..5
      @star_empty.draw(@x+41+22*i, @y+15, Zorder::GUI_Bkgrd)
    end
    for i in 1..$stars2
      @star_full.draw(@x+41+22*i, @y+15, Zorder::GUI)
    end

    @spell_empty.draw(@x+178, @y+15, Zorder::GUI_Bkgrd)
    if $spell2 == "stun"
      @stun.draw(@x+178, @y+15, Zorder::GUI)
    end
    if $spell2 == "mist"
      @mist.draw(@x+178, @y+15, Zorder::GUI)
    end
	end
end


=begin  def power_up
    if $power_ups2 == 1
      @power_ups_text.text = "Speed"
      @power_ups_text.x = 110 - @power_ups_text.width/2
    elsif $power_ups2 == 2
      @power_ups_text.text = "Creep"
      @power_ups_text.x = 110 - @power_ups_text.width/2
    else
      @power_ups_text.text = "Bump"
      @power_ups_text.x = 110 - @power_ups_text.width/2
    end
  end
=end

#  def update
#    super
#    @power_ups_text.text = "Power Ups: #{$power_ups2}"
#    @spell_text.text = "Spell: #{$spell2}"
#  end
