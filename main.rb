require 'rubygems'
require 'gosu'
require File.join(File.dirname(__FILE__), "libs", 'player')
require File.join(File.dirname(__FILE__), "libs", 'start')

module ZOrder 
  Background, Stars, Player, UI = *0..3 
end

class GameWindow < Gosu::Window
  def initialize
    super(640, 480, false)
    self.caption = "Gosu Tutorial Game"
    
    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)
    
    @background_image = Gosu::Image.new(self, "media/background.bmp", true)
    
    @star_anim = Gosu::Image::load_tiles(self, "media/Star.png", 25, 25, false)
    @stars = Array.new
    
    @player = Player.new(self)
    @player.warp(320, 240)
  end

  def update
    if button_down? Gosu::Button::KbLeft or button_down? Gosu::Button::GpLeft
      @player.left
    elsif button_down? Gosu::Button::KbRight or button_down? Gosu::Button::GpRight
      @player.right
    else
      @player.stabilize    
    end
    
    if button_down? Gosu::Button::KbUp or button_down? Gosu::Button::GpButton0 then @player.up end
    if button_down? Gosu::Button::KbDown or button_down? Gosu::Button::GpButton0 then @player.down end
      
    @player.move
    @player.collect_stars(@stars)
    if rand(100) < 10 and @stars.size < 25 then 
      @stars.push(Star.new(@star_anim)) 
    end
    
    @stars.delete_if{|star| star.y > 500}
  end

  def draw
    @player.draw
    @background_image.draw(0, 0, ZOrder::Background)
    @stars.each { |star| star.draw }
    @font.draw("Score: #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, 0xffffff00) 
  end
  
  
  def button_down(id)
    if id == Gosu::Button::KbEscape
      close
    end
  end
end

window = GameWindow.new
window.show


