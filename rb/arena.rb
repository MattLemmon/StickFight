
require_relative 'lense_flares'

=begin
class Arena < Chingu::GameState
  trait :timer
  def setup
    ####################################################
    $difficulty = "Normal"
    $score1 = 0
    $score2 = 0
    $mode = "Campaign"
    $image1 = "shaman"
    $image2 = "ninja"
    $round = 1
    $pos1_x, $pos1_y = 740, 300
    $pos2_x, $pos2_y = 60, 300
    $stars1 = 0
    $stars2 = 0
    $speed1 = 3.2
    $speed2 = 3.2
    $power_ups1 = 0
    $power_ups2 = 0
    $creep1 = false
    $creep2 = false
    $chest_bump1 = false
    $chest_bump2 = false
    $kick1 = false
    $kick2 = false
    $spell1 = "none"
    $spell2 = "none"
    ####################################################
    $health1 = 10
    $health2 = 10
    $start_health1 = 10
    $start_health2 = 10
    after(200){push_game_state(RoundChange)}
  end
end
=end


#
# ARENA 1 GAMESTATE
#
class Arena1 < Chingu::GameState    
  trait :timer
  attr_reader :puck, :player1, :player2, :peons1, :peons2

  def initialize
    super
    LenseFlares.load_images $window, './media/lense_flares'
    @lense_flares = LenseFlares.new $window.width/2.0, $window.height/2.0
    @star_flares = {}
    #@mist = Ashton::Shader.new fragment: './rb/mist.frag', uniforms: { time: 0.0, alpha: 0.5, mist_color: [230/255.0, 250/255.0, 255/255.0, 1.0] }

    @rare_drops = ["heart", "stun", "mist"]
    @r = 0
    @drop_vel_x = 0
    @drop_vel_y = 0

    self.input = { :p => Pause,
                   :space => :attack,
                   :j => :decrease_volume,
                   :l => :increase_volume,
                   :i => :increase_volume,
                   :k => :decrease_volume,
                   :holding_right_ctrl=>:chest_bump1,
                   :holding_left_ctrl=>:chest_bump2,
                   :right_shift=>:right_attack,
                   :left_shift=>:left_attack,
                   :left_mouse_button => :start_selecting, 
                   :released_left_mouse_button => :stop_selecting,
                   :right_mouse_button => :go_to_destination,
                   :released_right_mouse_button => :stop_attacking
                 }

    $window.caption = "Stick Ball - Round #{$round}"
  end

  def setup
    super
    $health1 = $start_health1
    $health2 = $start_health2
    $destination_x = 400
    $destination_y = 300

    @seconds = 30

    @bumping1 = false
    @bumping2 = false

    @bump = 0
    @bump_delay = 15
    @bounce = 0
    @bounce_delay = 6
    @spell1_hit = false
    @spell2_hit = false
    @shake1 = 10
    @shake2 = 5
    @song_fade = false
    @fade_count = 0
    @chant = "Prepare for MultiBall"
    @multiball = false
    @ending = false
    @transition = true

    game_objects.destroy_all
    Referee.destroy_all
    Player1.destroy_all
    Player2.destroy_all
#    EyesLeft.destroy_all
#    EyesRight.destroy_all

    if @health1_text != nil; @health1_text.destroy; end # if it exists, destroy it
    if @health2_text != nil; @health2_text.destroy; end # if it exists, destroy it

    FireCube.destroy_all
    Star.destroy_all
    #LenseFlares.destroy_all
    #if @player != nil; @player.destroy; end 

    @referee = Referee.create(:x => 400, :y => 300, :zorder => Zorder::Main_Character)

    @player1 = Player1.create(:x => $pos1_x, :y => $pos1_y, :zorder => Zorder::Main_Character)#(:x => $player_x, :y => $player_y, :angle => $player_angle, :zorder => Zorder::Main_Character)
#    if $mode == "Versus"
      @player1.input = {:holding_left=>:go_left,:holding_right=>:go_right,:holding_up=>:go_up,:holding_down=>:go_down} #:holding_right_ctrl=>:creep,
#    end

#    @stick1 = Stick1.create(:x => @player1.x - 20, :y => @player1.y, :zorder => Zorder::Face)

    @player2 = Player2.create(:x => $pos2_x, :y => $pos2_y, :zorder => Zorder::Main_Character)#(:x => $player_x, :y => $player_y, :angle => $player_angle, :zorder => Zorder::Main_Character)
#    if $mode == "Versus"
      @player2.input = {:holding_a=>:go_left,:holding_d=>:go_right,:holding_w=>:go_up,:holding_s=>:go_down} #:holding_left_ctrl=>:creep,
#    end

    @stick2 = Stick2.create(:x => @player2.x + 20, :y => @player2.y, :zorder => Zorder::Face)

   # Player1.create(:x => $pos1_x - 50, :y => $pos1_y - 50, :zorder => Zorder::Main_Character)
  #  Player1.create(:x => $pos1_x - 50, :y => $pos1_y + 50, :zorder => Zorder::Main_Character)
 #   Player1.create(:x => $pos1_x + 50, :y => $pos1_y + 50, :zorder => Zorder::Main_Character)
#    Player1.create(:x => $pos1_x + 50, :y => $pos1_y - 50, :zorder => Zorder::Main_Character)
#    @peons = Array.new(4) {Player1.create}

    @peons1 = []
    create_peons1

    @peons2 = []
    create_peons2

#    Player2.create(:x => $pos2_x + 50, :y => $pos2_y - 50, :zorder => Zorder::Main_Character)
 #   Player2.create(:x => $pos2_x + 50, :y => $pos2_y + 50, :zorder => Zorder::Main_Character)
  #  Player2.create(:x => $pos2_x - 50, :y => $pos2_y - 50, :zorder => Zorder::Main_Character)
   # Player2.create(:x => $pos2_x - 50, :y => $pos2_y + 50, :zorder => Zorder::Main_Character)


    if $mode == "Campaign"
      campaign_setup
    end

    @health1_text = Chingu::Text.create(:text=>"#{$health1}", :y=>16, :size=>32)
    @health1_text.x = 765 - @health1_text.width/2

    @health2_text = Chingu::Text.create(:text=>"#{$health2}", :y=>16, :size=>32)
    @health2_text.x = 36 - @health2_text.width/2

    @score1_text = Chingu::Text.create(:text=>"#{$score1}", :y=>18, :size=>32)
    @score1_text.x = 500 - @score1_text.width/2

    @score2_text = Chingu::Text.create(:text=>"#{$score2}", :y=>18, :size=>32)
    @score2_text.x = 300 - @score2_text.width/2

    @gui1 = GUI1.create
    @gui2 = GUI2.create

    @round_text = Chingu::Text.create(:text=>"Round #{$round}", :y=>8, :size=>34)
    @round_text.x = 400 - @round_text.width/2

#    @puck = FireCube.create(:zorder => Zorder::Projectile)
#    @puck_flare = @lense_flares.create @puck.x, @puck.y, Zorder::LenseFlare
#    @puck_flare.brightness = 0.25
#    @puck_flare.strength = 0.3
#    @puck_flare.scale = 1.0

    @timer_text = Chingu::Text.create("Multiball in :#{@seconds}", :y => 36, :font => "GeosansLight", :size => 26, :zorder => Zorder::GUI)
    @timer_text.x = 400 - @timer_text.width/2

    $music.volume = 0.0

    @selecting = false

    round_setup

    after(1000) { tock }

    after(2400) { @transition = false }

#    1.times { fire }
  end

  def create_peons1 # creates 15 characters (one of each) each time it is called 
    @peons1 << Player1.create(:x=> @player1.x, :y=> @player1.y - 100, :zorder => Zorder::Main_Character)
    @peons1 << Player1.create(:x=> @player1.x, :y=> @player1.y - 50, :zorder => Zorder::Main_Character)
    @peons1 << Player1.create(:x=> @player1.x, :y=> @player1.y + 50, :zorder => Zorder::Main_Character)
    @peons1 << Player1.create(:x=> @player1.x, :y=> @player1.y + 100, :zorder => Zorder::Main_Character)
  end

  def create_peons2 # creates 15 characters (one of each) each time it is called 
    @peons2 << Player2.create(:x=> @player2.x, :y=> @player2.y - 100, :zorder => Zorder::Main_Character)
    @peons2 << Player2.create(:x=> @player2.x, :y=> @player2.y - 50, :zorder => Zorder::Main_Character)
    @peons2 << Player2.create(:x=> @player2.x, :y=> @player2.y + 50, :zorder => Zorder::Main_Character)
    @peons2 << Player2.create(:x=> @player2.x, :y=> @player2.y + 100, :zorder => Zorder::Main_Character)
  end


  def attack
    Player1.each do |player|
      if player.selected == true
        closest = player.seek_opponent(@peons2)
        player.preattack
        player.attack(closest)
        after(1000){player.unattack}
      end
    end
  end

  def start_selecting
    puts "start selecting"
    $start_x = $window.mouse_x
    $start_y = $window.mouse_y
    puts "x = #{$window.mouse_x}"
    puts "y = #{$window.mouse_y}"
    @selecting = true #Selector.create
  end
  def stop_selecting
    puts "stop selecting"
    $stop_x = $window.mouse_x
    $stop_y = $window.mouse_y
    puts "x = #{$window.mouse_x}"
    puts "y = #{$window.mouse_y}"
    Player1.each do |player1|
      player1.deselect
      if player1.x <= $stop_x && player1.x >= $start_x
        if player1.y <= $stop_y && player1.y >= $start_y
          player1.select
        end
        if player1.y >= $stop_y && player1.y <= $start_y
          player1.select
        end
      end
      if @player1.x >= $stop_x && player1.x <= $start_x
        if player1.y <= $stop_y && player1.y >= $start_y
          player1.select
        end
        if player1.y >= $stop_y && player1.y <= $start_y
          player1.select
        end
      end
    end
    Player2.each do |player2|
      player2.deselect
      if player2.x <= $stop_x && player2.x >= $start_x
        if player2.y <= $stop_y && player2.y >= $start_y
          player2.select
        end
        if player2.y >= $stop_y && player2.y <= $start_y
          player2.select
        end
      end
      if player2.x >= $stop_x && player2.x <= $start_x
        if player2.y <= $stop_y && player2.y >= $start_y
          player2.select
        end
        if player2.y >= $stop_y && player2.y <= $start_y
          player2.select
        end
      end
      @selecting = false #Selector.destroy_all
    end
  end
  def go_to_destination
    puts "go to destination"
    $destination_x = $window.mouse_x
    $destination_y = $window.mouse_y
    Player1.each do |player1|
      player1.going
    end
    Player2.each do |player2|
      player2.going
    end
  end
  def stop_attacking
#    puts "stop attacking"
  end

  def campaign_setup
    @player1.x = 750
    @player2.x = 50
    if $difficulty == "Easy"
      $speed2 = 2.8
      $health2 = 10
    end
    if $difficulty == "Normal"
      $kick1 = true
      $speed1 = 8
      $health1 = 15
      $kick2 = true
      $speed2 = 8
      $health2 = 15
    end
    if $difficulty == "Hard"
      $speed2 = 10
      $kick2 = true
      $health2 = 30
    end
    if $difficulty == "Insane"
      $speed2 = 12
      $kick2 = true
      $health2 = 40
    end
  end

  def round_setup
    if $round == 1
      Background1.create
      #Background2.create
      #Gang.create
      #Background6.create
      after(500) {
        $music = Song["media/audio/8_bit_remix.ogg"]
        $music.volume = 0.7
        $music.play(true)
      }
    end
    if $round == 2
      Background2.create
      after(500) {
        $music = Song["media/audio/electricity_by_alexander_blu.ogg"]
        $music.volume = 0.7
        $music.play(true)
      }
    end
    if $round == 3
      Crowd.create
      after(500) {
        $music = Song["media/audio/guitar_song.ogg"]
        $music.volume = 0.6
        $music.play(true)
      }
      after(10900) { $music.volume = 0.5 }
      after(22400) { $music.volume = 0.4 }
      after(22900) { $music.volume = 0.3 }
    end
  end

  def increase_volume
    $music.volume += 0.1
  end

  def decrease_volume
    $music.volume -= 0.1
  end

  def right_attack
    @player1.cast_spell
  end
  
  def left_attack
    @player2.cast_spell
  end

  def chest_bump1
      @bumping1 = true
  end

  def chest_bump2
      @bumping2 = true
  end

  def tock
    if @ending == false
      if @seconds != 0
        after(1000) { @seconds -= 1
          @timer_text.text = "Multiball in :#{@seconds}"
          tock
        }
      else
        @timer_text.text = ""
        start_multiball
      end
    else
      @timer_text.text = ""
    end
  end

  def start_multiball
    if @multiball == false
      @multiball = true
      @chant_text = Chingu::Text.create("#{@chant}", :y => 520, :size => 50, :zorder => Zorder::GUI)
      @chant_text.x = 400 - @chant_text.width/2
      after(400) { @chant_text.text = "" }
      after(800) { @chant_text.text = "#{@chant}" }
      after(1200) { @chant_text.text = "" }
      after(1600) { @chant_text.text = "#{@chant}" }
      after(2000) { @chant_text.text = "" }
      after(2400) { @chant_text.text = "#{@chant}" }
      after(2800) { @chant_text.text = "" }
      after(3200) {
#        @puck2 = FireCube.create(:zorder => Zorder::Projectile)
#        @puck3 = FireCube.create(:x => rand($window.width), :y => rand($window.height), :zorder => Zorder::Projectile)
      }
      after(14000) { 
#        @puck2.destroy
#        @puck3.destroy
        @multiball = false
        @seconds = 31
        tock
      }
    end
  end


  def screen_shake1
    blink_flare
    game_objects.each do |object|
      object.x += @shake1
      after(30) {object.y += @shake2}
      after(60) {object.x -= @shake1}
      after(90) {object.y -= @shake2}
      after(120) {object.x += @shake1}
      after(150) {object.y += @shake2}
      after(180) {object.x -= @shake1}
      after(210) {object.y -= @shake2}
    end
  end

  def screen_shake2
    blink_flare
    game_objects.each do |object|  # move each object left first
      object.x -= @shake1
      after(30) {object.y += @shake2}
      after(60) {object.x += @shake1}
      after(90) {object.y -= @shake2}
      after(120) {object.x -= @shake1}
      after(150) {object.y += @shake2}
      after(180) {object.x += @shake1}
      after(210) {object.y -= @shake2}
    end
  end

  def move_referee
=begin    if @referee.y > @puck.y && rand(7) == 1
      @referee.go_up
      @referee.update_face
    end
    if @referee.y < @puck.y && rand(7) == 1
      @referee.go_down
      @referee.update_face
    end
    if @referee.x > @puck.x && @referee.x > 300 && rand(20) == 1
      @referee.go_left
      @referee.update_face
    end
    if @referee.x < @puck.x && @referee.x < 500 && rand(20) == 1
      @referee.go_right
      @referee.update_face
    end
=end
  end

  def player1_power_up
    if $power_ups1 == 1
      $speed1 = 8.5
    end
    if $power_ups1 == 2
      $chest_bump1 = true
    end
    if $power_ups1 == 3
      $kick1 = true
    end
  end

  def player2_power_up
    if $power_ups2 == 1
      $speed2 = 8.5
    end
    if $power_ups2 == 2
      $chest_bump2 = true
    end
    if $power_ups2 == 3
      $kick2 = true
    end
  end

  def blink_flare
    @star_flares.each do |star, flare|        # UPDATE STAR FLARES
      after(30)  { flare.brightness += 0.6; flare.strength += 0.3;  }
      after(90)  { flare.brightness -= 0.3; flare.strength -= 0.15;  }
      after(100) { flare.brightness -= 0.3; flare.strength -= 0.15;  }
    end
  end

  def add_star options
    star = Star.create options
    flare = @lense_flares.create star.x, star.y, Zorder::LenseFlare
    flare.color = star.color
    flare.strength = 0.25
    flare.brightness = 0.3
    flare.scale = 1.25
    flare.flickering = 0.1
    @star_flares[star] = flare
  end
  
  def remove_star star
    flare = @star_flares.delete star
    @lense_flares.delete flare
    star.destroy
  end

  def create_heart
    Heart.create(:x => @referee.x, :y => @referee.y, :velocity_x => @drop_vel_x, :velocity_y => @drop_vel_y )
  end
  def create_stun
    Stun.create(:x => @referee.x, :y => @referee.y, :velocity_x => @drop_vel_x, :velocity_y => @drop_vel_y )
  end
  def create_mist
    Mist.create(:x => @referee.x, :y => @referee.y, :velocity_x => @drop_vel_x, :velocity_y => @drop_vel_y )
  end

  def rare_drop
    @r = rand(3)
    @rare_drop = @rare_drops[@r]
    #puts @rare_drop
    if @rare_drop == "heart"
      create_heart
    end
    if @rare_drop == "stun"
      create_stun
    end
    if @rare_drop == "mist"
      create_mist
    end
    if rand(3) == 1
      @drop_vel_y *= -1
      add_star :x => @referee.x, :y => @referee.y, :velocity_x => @drop_vel_x, :velocity_y => @drop_vel_y
    end
  end

  def collision_check
    @star_flares.each do |star,flare|        # UPDATE STAR FLARES
      flare.x = star.x
      flare.y = star.y
    end

    Player1.each_collision(Player1) do |player, player1|
#      player.ungoing
      if player1.x - $destination_x < 50 && player1.x - $destination_x > -50 && player1.y - $destination_y < 50 && player1.y - $destination_y > -50
        player1.ungoing
      end
      if player.x > player1.x
        player.velocity_x = 2
        player1.velocity_x = -2
      else
        player.velocity_x = -2
        player1.velocity_x = 2
      end
      if player.y > player1.y
        player.velocity_y = 2
        player1.velocity_y = -2
      else
        player.velocity_y = -2
        player1.velocity_y = 2
      end
    end

    Player2.each_collision(Player2) do |player, player2|
#      player.ungoing
      if player2.x - $destination_x < 50 && player2.x - $destination_x > -50 && player2.y - $destination_y < 50 && player2.y - $destination_y > -50
        player2.ungoing
      end
      if player.x > player2.x
        player.velocity_x = 2
        player2.velocity_x = -2
      else
        player.velocity_x = -2
        player2.velocity_x = 2
      end
      if player.y > player2.y
        player.velocity_y = 2
        player2.velocity_y = -2
      else
        player.velocity_y = -2
        player2.velocity_y = 2
      end
    end

    Spell1.each do |spell|                   # SPELL 1 MOVEMENT
      if spell.y < @player2.y
        spell.velocity_y = 20.0
      end
      if spell.y > @player2.y
        spell.velocity_y = -20.0
      end
      if spell.y == @player2.y
        spell.velocity_y = 0
      end
      if spell.x < @player2.x
        spell.velocity_x = 30.0
      end
      if spell.x > @player2.x
        spell.velocity_x = -30.0
      end
      if spell.x == @player2.x
        spell.velocity_x = 0
      end
    end
    Spell2.each do |spell|                   # SPELL 2 MOVEMENT
      if spell.y < @player1.y
        spell.velocity_y = 20.0
      end
      if spell.y > @player1.y
        spell.velocity_y = -20.0
      end
      if spell.y == @player1.y
        spell.velocity_y = 0
      end
      if spell.x < @player1.x
        spell.velocity_x = 30.0
      end
      if spell.x > @player1.x
        spell.velocity_x = -30.0
      end
      if spell.x == @player1.x
        spell.velocity_x = 0
      end
    end

    Player1.each_collision(Spell2) do |player, spell|    # HIT PLAYER 1 WITH SPELL2
      if @spell2_hit == false
        @spell2_hit = true
        if spell.spell_type == "stun"
          player.stun
        end
        if spell.spell_type == "mist"
          player.mist
        end
        if spell.spell_type == "strike"
          player.damage
          $health1 -= 1
          @health1_text.text = "#{$health1}"
          @health1_text.x = 765 - @health1_text.width/2
        end
        spell.destroy
        after(300) { @spell2_hit = false }
      else
        after(50) { spell.destroy }
      end
      break   #   Explosion.create(:x => spell.x, :y => spell.y)
    end
    Player2.each_collision(Spell1) do |player, spell|    # HIT PLAYER 2 WITH SPELL1
     if @spell1_hit == false
        @spell1_hit = true
        if spell.spell_type == "stun"
          player.stun
        end
        if spell.spell_type == "mist"
          player.mist
        end
        if spell.spell_type == "strike"
          player.damage
          $health2 -= 1
          @health2_text.text = "#{$health2}"
          @health2_text.x = 38 - @health2_text.width/2
        end
        spell.destroy
        after(300) { @spell1_hit = false }
      else
        after(50) { spell.destroy }
      end
      break   #   Explosion.create(:x => spell.x, :y => spell.y)
    end

    Player1.each_collision(Star) do |player, star|    # PICKUP STARS
      remove_star star
      $stars1 += 1
      if $stars1 != 5
        $star_grab_right.play(0.9)
      else
        $power_up_right.play(0.7)
        $stars1 = 0
        $power_ups1 += 1
        player1_power_up       # Power Up!
        @gui1.power_up
      end
    end
    Player2.each_collision(Star) do |player, star|    # PICKUP STARS
      remove_star star
      $stars2 += 1
      if $stars2 != 5
        $star_grab_left.play(0.9)
      else
        $power_up_left.play(0.7)
        $stars2 = 0
        $power_ups2 += 1
        player2_power_up       # Power Up!
        @gui2.power_up
      end
    end

   Player1.each_collision(Heart) do |player, heart|    # PICKUP HEARTS
      heart.destroy
      $health1 += 1
      @health1_text.text = "#{$health1}"
      @health1_text.x = 765 - @health1_text.width/2
      $one_up_right.play(0.7)
    end
    Player2.each_collision(Heart) do |player, heart|    # PICKUP HEARTS
      heart.destroy
      $health2 += 1
      @health2_text.text = "#{$health2}"
      @health2_text.x = 36 - @health2_text.width/2
      $one_up_left.play(0.7)
    end

   Player1.each_collision(Stun) do |player, stun|    # PICKUP STUNS
      stun.destroy
      $spell1 = "stun"
      $stun_grab_right.play(0.9)
    end
    Player2.each_collision(Stun) do |player, stun|    # PICKUP STUNS
      stun.destroy
      $spell2 = "stun"
      $stun_grab_left.play(0.9)
    end

   Player1.each_collision(Mist) do |player, mist|    # PICKUP MISTS
      mist.destroy
      $spell1 = "mist"
      $mist_grab_right.play(0.7)
    end
    Player2.each_collision(Mist) do |player, mist|    # PICKUP MISTS
      mist.destroy
      $spell2 = "mist"
      $mist_grab_left.play(0.7)
    end
  end

  def draw
    @lense_flares.draw
    if @selecting == true
      draw_rect([$start_x,$start_y,$window.mouse_x-$start_x,$window.mouse_y-$start_y], Color::WHITE, 10) #, :multiply)
    end
    if $round == 2
      fill_gradient(:from => Color.new(0xFF00003B), :to => Color.new(0xFF252546), :orientation => :vertical)
    end
    super
  end


  def update
    @lense_flares.update
    #@mist.time = Gosu.milliseconds/1000.0
    super

    if rand(500) == 1
      @drop_vel_x = 5 - rand(11)
      @drop_vel_y = 5 - rand(11)
      rare_drop
    end
    if rand(1000) == 1; screen_shake1; end

    move_referee
    collision_check
#    @stick1.x = @player1.x - 20
#    @stick1.y = @player1.y
    @stick2.x = @player2.x + 20
    @stick2.y = @player2.y
    $pos1_x, $pos1_y = @player1.x, @player1.y
    $pos2_x, $pos2_y = @player2.x, @player2.y
    @bumping1 = false
    @bumping2 = false

    if @bump > 0
      @bump -= 1
    end
    if @bounce > 0
      @bounce -= 1
    end


    if $mode == "Campaign"
      if $difficulty == "Easy"
#        if @player2.y > @puck.y && rand(6) == 1
#          @player2.go_up
#        end
#        if @player2.y < @puck.y && rand(6) == 1
#          @player2.go_down
#        end
      end
      if $difficulty == "Normal" || $difficulty == "Hard" || $difficulty == "Insane"
#        if @player2.y > @puck.y && rand(3) == 1
#          @player2.go_up
#        end
#        if @player2.y < @puck.y && rand(3) == 1
#          @player2.go_down
#        end
#        if @player1.y > @puck.y && rand(3) == 1
#          @player1.go_up
#        end
#        if @player1.y < @puck.y && rand(3) == 1
#          @player1.go_down
#        end
      end
      if $difficulty == "Normal"
#        if rand(100) == 1
#          if rand(5) == 1
#            $spell2 = "stun"
#          elsif rand(4) == 1
#            $spell2 = "mist"
#          else
#            $spell2 = "strike"
#          end
#          @player2.cast_spell
#          @stick2.wiggle
#        end
#        if rand(100) == 1
#          if rand(5) == 1
#            $spell1 = "stun"
#          elsif rand(4) == 1
#            $spell1 = "mist"
#          else
#            $spell1 = "strike"
#          end
#          @player1.cast_spell
#          @player1.wiggle_stick
#        end
      end
      if $difficulty == "Hard"
        if rand(300) == 1
          if rand(2) == 1
            $spell2 = "stun"
          else
            $spell2 = "mist"
          end
          @player2.cast_spell
        end
      end
      if $difficulty == "Insane"
        if rand(160) == 1
          if rand(2) == 1
            $spell2 = "stun"
          else
            $spell2 = "mist"
          end
          @player2.cast_spell
        end
      end
    end

    self.game_objects.destroy_if { |object| object.color.alpha == 0 }

    $window.caption = "Stick Ball - Round #{$round} - Objects: #{game_objects.size}, FPS: #{$window.fps}"

    if @song_fade == true # fade song if @song_fade is true
      @fade_count += 1
      if @fade_count == 20
        @fade_count = 0
        $music.volume -= 0.1
      end
    end
  end
end


#    @score1_text.text = "#{$score1}"
#    @score2_text.text = "#{$score2}"
#    @health1_text.text = "#{$health1}"
#    @health2_text.text = "#{$health2}"

#    @eyes1.x = @player1.x - 3
#    @eyes1.y = @player1.y - 12
#    @eyes2.x = @player2.x + 3
#    @eyes2.y = @player2.y - 12


    #
    # GameObject.each_collsion / each_bounding_box_collision wont collide an object with itself
    #
    # FireCube.each_bounding_circle_collision(FireCube) do |cube1, cube2|  # 30 FPS on my computer
    #
    # Let's see if we can optimize each_collision, starts with 19 FPS with radius collision
    # 30 FPS by checking for radius and automatically delegate to each_bounding_circle_collision
    #
    # For bounding_box collision we start out with 7 FPS
    # Got 8 FPS, the bulk CPU consumtion is in the rect vs rect check, not in the loops.
    #