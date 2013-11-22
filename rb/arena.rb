
#
# ARENA GAMESTATE
#
class Arena < Chingu::GameState    
  trait :timer
  trait :viewport
  attr_reader :player1, :player2, :peons1, :peons2

  def initialize
    super

    self.input = { :p => Pause,
                   :space => :attack,
                   :i => :increase_volume,
                   :k => :decrease_volume,
                   :j => :change_track,
                   :l => :change_track,

                   :left_mouse_button => :start_selecting, 
                   :released_left_mouse_button => :stop_selecting,
                   :right_mouse_button => :go_to_destination,

                   :b => :build_farm,
                   :v => :build_rampart
                 }

    viewport.lag  = 0.22
    viewport.game_area = [0, 0, 1000*3, 1000*3]

    $window.caption = "Stick Fight - Simple RTS Game"
  end

  def setup
    super
    $image1 = "shaman"
    $image2 = "ninja"

    $lumber1 = 20
    $lumber2 = 20
    $destination_x = 400
    $destination_y = 300

    @shake1 = 10
    @shake2 = 5
    @song_fade = false
    @fade_count = 0

    @seconds = 0
    @music_track = 1

    game_objects.destroy_all
    Player1.destroy_all
    Player2.destroy_all

    if @lumber1_text != nil; @lumber1_text.destroy; end # if it exists, destroy it
    if @lumber2_text != nil; @lumber2_text.destroy; end # if it exists, destroy it


    @player1 = Player1.create(:x => $pos1_x, :y => $pos1_y, :zorder => Zorder::Main_Character)#(:x => $player_x, :y => $player_y, :angle => $player_angle, :zorder => Zorder::Main_Character)
    @player1.input = {:holding_left=>:go_left,:holding_right=>:go_right,:holding_up=>:go_up,:holding_down=>:go_down} #:holding_right_ctrl=>:creep,

    @player2 = Player2.create(:x => $pos2_x, :y => $pos2_y, :zorder => Zorder::Main_Character)#(:x => $player_x, :y => $player_y, :angle => $player_angle, :zorder => Zorder::Main_Character)
    @player2.input = {:holding_a=>:go_left,:holding_d=>:go_right,:holding_w=>:go_up,:holding_s=>:go_down} #:holding_left_ctrl=>:creep,

    @peons1 = []
    create_peons1

    @peons2 = []
    create_peons2

    if $mode == "Campaign"
      campaign_setup
    end

    @lumber1_text = Chingu::Text.create(:text=>"#{$lumber1}", :y=>16, :size=>32)
    @lumber1_text.x = 765 - @lumber1_text.width/2

    @lumber2_text = Chingu::Text.create(:text=>"#{$lumber2}", :y=>16, :size=>32)
    @lumber2_text.x = 36 - @lumber2_text.width/2

    @score1_text = Chingu::Text.create(:text=>"#{$score1}", :y=>18, :size=>32)
    @score1_text.x = 500 - @score1_text.width/2

    @score2_text = Chingu::Text.create(:text=>"#{$score2}", :y=>18, :size=>32)
    @score2_text.x = 300 - @score2_text.width/2

    @gui1 = GUI1.create
    @gui2 = GUI2.create

    @minimap = MiniMap.new

    @round_text = Chingu::Text.create(:text=>"Arena", :y=>8, :size=>34)
    @round_text.x = 400 - @round_text.width/2

    @timer_text = Chingu::Text.create("Seconds :#{@seconds}", :y => 36, :font => "GeosansLight", :size => 26, :zorder => Zorder::GUI)
    @timer_text.x = 400 - @timer_text.width/2

    @selecting = false

    after(1000) { tock }

    after(2000) { change_track }
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
    Player2.each do |player|
      if player.selected == true
        closest = player.seek_opponent(@peons1)
        player.attack(closest)
      end
    end
  end

  def build_farm
    Player1.each do |player| ; if player.selected == true; player.build_farm; end; end
    Player2.each do |player| ; if player.selected == true; player.build_farm; end; end
  end
  def build_rampart
    Player1.each do |player| ; if player.selected == true; player.build_rampart; end; end
    Player2.each do |player| ; if player.selected == true; player.build_rampart; end; end
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

  def increase_volume;  $music.volume += 0.1;  end
  def decrease_volume;  $music.volume -= 0.1;  end

  def change_track
    if @music_track == 1
      $music = Song["audio/intro_song.ogg"]
      $music.volume = 0.6
      $music.play(true)
      @music_track = 2
    else
      $music = Song["audio/end_song.ogg"]
      $music.volume = 0.6
      $music.play(true)
      @music_track = 1
    end
  end

  def tock
    after(1000) { @seconds += 1
      @timer_text.text = "Seconds :#{@seconds}"
      tock }
  end

  def screen_shake
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

  def move_referee
  end

  def collision_check

    Player1.each_collision(Player1) do |player, player1|
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
  end

  def draw
    @minimap.draw
    if @selecting == true
      draw_rect([$start_x,$start_y,$window.mouse_x-$start_x,$window.mouse_y-$start_y], Color::WHITE, 10) #, :multiply)
    end
    super
  end

  def update
    self.viewport.center_around(@player2)
    @minimap.update
    super

    collision_check
    $pos1_x, $pos1_y = @player1.x, @player1.y
    $pos2_x, $pos2_y = @player2.x, @player2.y

    self.game_objects.destroy_if { |object| object.color.alpha == 0 }

    $window.caption = "Stick Fight - Simple RTS Game - Objects: #{game_objects.size}, FPS: #{$window.fps}"

    if @song_fade == true # fade song if @song_fade is true
      @fade_count += 1
      if @fade_count == 20
        @fade_count = 0
        $music.volume -= 0.1
      end
    end
  end
end

