
#
#  BEGINNING GAMESTATE
#
class Beginning < Chingu::GameState
  trait :timer
  def setup
    $difficulty = "Normal"
    $score1 = 0
    $score2 = 0
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
    $lumber1 = 10
    $lumber2 = 10
    $start_health1 = 10
    $start_health2 = 10
    $start_lumber1 = 10
    $start_lumber2 = 10
    after(100){push_game_state(Arena)}
  end
end


