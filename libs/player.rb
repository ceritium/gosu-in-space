class Player
  attr_reader :score

  def initialize(window)
    @image = Gosu::Image.new(window, "media/xwing.png", false)
    @beep = Gosu::Sample.new(window, "media/Beep.wav")
    @x = @y = @vel_x = @vel_y = @angle = 0.0
    @score = 0
  end

  def collect_stars(stars) 
    stars.reject! do |star| 
      if Gosu::distance(@x, @y,  star.x, star.y) < 40
        @score += 10 
        @beep.play 
        true 
      else 
        false 
      end 
    end 
  end 


  def warp(x, y)
    @x, @y = x, y
  end



  def left
    @angle -= 3.0 if @angle > -33
  end

  def right
    @angle += 3.0 if @angle < 33
  end

  def down
    @vel_y += 0.9
  end

  def up
    @vel_y -= 0.9
  end
  
  def stabilize
    @angle += 0.9 if @angle < 0
    @angle -= 0.9 if @angle > 0
    @angle = 0 if @angle.abs < 0.7
  end

  def move
    @y += @vel_y
    @y = 440 if @y > 440
    @y = 40 if @y < 40
    @x += Gosu::offset_x(@angle, 16)
    @x %= 640
    @vel_y *= 0.9
  end

  def draw
    @image.draw_rot(@x, @y, 1, @angle)
  end



end
