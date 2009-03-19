class Shot
  attr_reader :y, :x, :time
  def initialize(window, x, y, angle) 
    @image = Gosu::Image.new(window, "media/empire_laser.png", false)
    @vel_x = @vel_y = @angle = 0.0
    @x, @y, @angle = x, y, angle
    @vel_x += Gosu::offset_x(@angle, 17) 
    @vel_y += Gosu::offset_y(@angle, 17)
    @time = Time.now
  end

  def destroy_tie(ties) 
    ties.reject! do |tie| 
      if Gosu::distance(@x, @y,  tie.x, tie.y) < 40
        true
      else 
        false 
      end 
    end 
  end 

  
  def draw 
    @x += @vel_x 
    @y += @vel_y 
    
    
    @image.draw_rot(@x, @y, 1, @angle)
  end 
end 
