
require 'chingu'
require 'gosu'
require 'texplay'
include Chingu
include Gosu

require_relative 'rb/players'
require_relative 'rb/objects'
require_relative 'rb/gui'
require_relative 'rb/beginning'
require_relative 'rb/ending'
require_relative 'rb/arena'
require_relative 'rb/buildings'

module Zorder
  GUI = 400
  GUI_Bkgrd = 399
  Text = 300
  Main_Character = 150
  Face = 151
  Eyes = 151
  Main_Character_Particles = 149
  Object = 50
  Projectile = 220
  LenseFlare = 221
  Particle = 210
  Background = 5
end

module Colors
  White = Gosu::Color.new(0xFFFFFFFF)
end


#
#  PAUSE GAMESTATE
#
class Pause < Chingu::GameState
  def initialize(options = {})
    super
    @title = Chingu::Text.create(:text=>"PAUSED (press 'P' to un-pause)", :y=>400, :size=>30, :color => Color.new(0xFF00FF00), :zorder=>1000 )
    @title.x = 400 - @title.width/2
    @t2 = Chingu::Text.create(:text=>"press 'R' to restart", :y=>450, :size=>30, :color => Color.new(0xFF00FF00), :zorder=>1000 )
    @t2.x = 400 - @t2.width/2
    @t3 = Chingu::Text.create(:text=>"press 'esc' to exit", :y=>500, :size=>30, :color => Color.new(0xFF00FF00), :zorder=>1000 )
    @t3.x = 400 - @t3.width/2

    self.input = { :p => :un_pause, :r => Beginning }
  end
  def un_pause
    pop_game_state(:setup => false)    # Return the previous game state, dont call setup()
  end  
  def draw
    previous_game_state.draw    # Draw prev game state onto screen
    super                       # Draw game objects in current game state, this includes Chingu::Texts
  end  
end



#
#  GameWindow Class
#
class GameWindow < Chingu::Window
  def initialize
    super(1000,800,false)
    @cursor = true # set to false to hide cursor
    self.caption = "Stick Fight"
    self.input = { :esc => :exit,
                   :z => :log      }
    $round = 1
    $intro = true
    $pos1_x, $pos1_y = 740, 300
    $pos2_x, $pos2_y = 60, 300
    $max_x = 3015
    $max_y = 3015
    $scr_edge = 15
    $image1 = "boy"
    $image2 = "boy"
    $click = Sound["media/audio/keypress.ogg"]
    $zapped = Sound["media/audio/magical_zap_by_qubodup.ogg"]
    $stunned = Sound["media/audio/stunned.ogg"]
    $misted = Sound["media/audio/misted.ogg"]
    $spell_cast = Sound["media/audio/magic_fireball_by_joelaudio.ogg"]
    $bang = Sound["media/audio/bang.ogg"]
    $game_over = Sound["media/audio/game_over.ogg"]
    $guitar_fill = Sound["media/audio/guitar_fill.ogg"]

    retrofy
  end

  def setup
    push_game_state(Beginning)
  end

  def log
    puts $window.current_game_state
  end
end

GameWindow.new.show
