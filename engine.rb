require 'gosu'
require 'chipmunk'

require './player'

require './constants'
require './utility'
include Utility

class GameWindow < Gosu::Window
  attr_accessor :background_image
  def initialize
    super SCREEN_WIDTH, SCREEN_HEIGHT, false
    self.caption = "Project Fantastic"
    @background_image = Gosu::Image.new(self, "media/background.png", true)

    # Time increment over which to apply a physics step
    @dt = (1.0/60.0)

    # Chipmunk space setup
    @space = CP::Space.new
    @space.gravity = Vec2.new(0.0, 9.8)
  end

  def update
  end

  def draw
  end
end
