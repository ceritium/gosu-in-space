require 'rubygems'
require 'gosu'
require File.join(File.dirname(__FILE__), "libs", 'player')
require File.join(File.dirname(__FILE__), "libs", 'star')
require File.join(File.dirname(__FILE__), "libs", 'tie')
require File.join(File.dirname(__FILE__), "libs", 'shot')


module ZOrder 
  Background, Stars, Player, UI = *0..3 
end

class GameWindow < Gosu::Window
  def initialize
    super(640, 480, false)
    self.caption = "Gosu Tutorial Game"
    
    # Cargamos fuentes y media
    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)
    @background_image = Gosu::Image.new(self, "media/background.bmp", true)
    @star_anim = Gosu::Image::load_tiles(self, "media/Star.png", 25, 25, false)
    
    # Inicializamos objetos
    @stars = Array.new
    @ties  = Array.new
    @shots = Array.new
    @player = Player.new(self)
    @player.warp(320, 240)
    
  end

  def update

    # Controles del jugador
    if button_down? Gosu::Button::KbLeft or button_down? Gosu::Button::GpLeft
      @player.left
    elsif button_down? Gosu::Button::KbRight or button_down? Gosu::Button::GpRight
      @player.right
    else
      @player.stabilize    
    end
    if button_down? Gosu::Button::KbSpace 
      if @shots.size == 0  || @shots.last.time < Time.now - 0.15
        #@shots.push(Shot.new(self, @player.x + Gosu::offset_x(@player.angle, 40) - 30, @player.y + Gosu::offset_y(@player.angle, 3)-20, @player.angle)) 
        @shots.push(Shot.new(self, @player.x + Gosu::offset_x(@player.angle, 45) + 30, @player.y - Gosu::offset_y(@player.angle, 3)-25, @player.angle))       
        @shots.push(Shot.new(self, @player.x + Gosu::offset_x(@player.angle, 45) - 30, @player.y - Gosu::offset_y(@player.angle, 3)-25, @player.angle))       
        
      end
    end
    if button_down? Gosu::Button::KbUp or button_down? Gosu::Button::GpButton0 then @player.up end
    if button_down? Gosu::Button::KbDown or button_down? Gosu::Button::GpButton0 then @player.down end
    if button_down? Gosu::Button::KbEscape then close end
    @player.move
    
    # Controlamos los shots
    @shots.delete_if{|shot| shot.y < -50}
    
    # Controlamos los tie
    if rand(500) < 10 and @ties.size < 10 then 
      @ties.push(Tie.new(self)) 
    end
    @ties.delete_if{|tie| tie.y > 500}
    @shots.each do |shot|
      shot.destroy_tie(@ties)
    end
    
    # Controlamos las estrellas
    @player.collect_stars(@stars)
    if rand(1000) < 10 and @stars.size < 5 then 
      @stars.push(Star.new(@star_anim)) 
    end
    @stars.delete_if{|star| star.y > 500}
    
    
  end

  def draw
    @background_image.draw(0, 0, ZOrder::Background)

    @ties.each { |tie| tie.draw }
    @stars.each { |star| star.draw }
    @shots.each { |shot| shot.draw}
    @player.draw
    @font.draw("Score: #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, 0xffffff00) 
  end
end

window = GameWindow.new
window.show


