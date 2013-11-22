
#
#   ENDING GAMESTATE
# 
class Ending < Chingu::GameState
  trait :timer
  def setup
    # Total Resources Collected
    # Total Units Trained
    # Total Kills
    # Total Deaths
    after(300) { $game_over.play(0.8) }
    after(6000) { push_game_state(Beginning) }
  end
end

