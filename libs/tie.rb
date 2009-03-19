class Tie
  attr_reader :x, :y
  def initialize(window) 
    @image = Gosu::Image.new(window, "media/tie_fighter.png", false)
    @vel_x = @vel_y = @angle = 0.0
    @x = rand(640)
    @y = -20
  end

  
  def draw 
    @y += 4
    @image.draw_rot(@x, @y, 1, @angle)
  end 
end 
