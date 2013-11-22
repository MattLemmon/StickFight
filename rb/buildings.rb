class Farm < Chingu::GameObject
  trait :timer
  def setup
    @image = Image["buildings/construction1.png"]
    after(1000) {@image = Image["buildings/construction2.png"]}
    after(2000) {@image = Image["buildings/farm.png"]}
  end
end
class Rampart < Chingu::GameObject
  trait :timer
  def setup
    @image = Image["buildings/construction1.png"]
    after(1000) {@image = Image["buildings/construction2.png"]}
    after(2000) {@image = Image["buildings/farm.png"]}
    @image = Image["buildings/rampart.png"]
  end
end