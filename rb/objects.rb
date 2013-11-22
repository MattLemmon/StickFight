
#
#  SELECTOR
#
class Selector < Chingu::GameObject
  def setup
    puts "selector"
  end
  def draw
    #@heart_meter.draw(@x+738, @y+4, 10)
    fill_rect([$start_x,$start_y,$window.mouse_x,$window.mouse_y], Color::WHITE)
  end
end

#
#  SELECTED BOX
#
class SelectedBox < Chingu::GameObject
  def setup
    self.factor = 0.7
    @image = Image["objects/selected_box.png"]
  end
end



#
#  STICK 1
#
class Stick1 < Chingu::GameObject
#  trait :timer
  def setup
    self.factor = 0.7
    @image = Image["players/#{$image1}_stick.png"]
  end
  def wiggle
    @angle -= 30
#    after(180) {@angle += 30}
  end
  def unwiggle
    @angle += 30
  end
end

#
#  STICK 2
#
class Stick2 < Chingu::GameObject
  def setup
    self.factor = 0.7
    @image = Image["players/#{$image2}_stick.png"]
  end
  def wiggle
    @angle += 30
  end
  def unwiggle
    @angle -= 30
  end
end



