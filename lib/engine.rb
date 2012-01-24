require 'gosu'
require 'chipmunk'

require './objects/player'
require './objects/walls'
require './objects/platform'

require './lib/constants'
require './lib/utility'
include Utility

class GameWindow < Gosu::Window
  attr_accessor :space, :background_image
  def initialize
    super SCREEN_WIDTH, SCREEN_HEIGHT, false
    self.caption = "Project Fantastic"
    @background_image = Gosu::Image.new(self, "media/background.png", true)

    # Time increment over which to apply a physics step
    @dt = (1.0/60.0)

    # Chipmunk space setup
    @space = CP::Space.new
    @space.gravity = Vec2.new(0.0, 9.8)

    # create walls
    Walls.new(self, SCREEN_WIDTH, SCREEN_HEIGHT)

    # DEBUG : create a platform
    @platform = Platform.new(self, 500, 500, 'media/dirtblocks.png')
  end

  def update
    # for each main update, we actually step the physics engine several times

    # ... control stuff that doesn't directly affect physics ...

    CP_SUBSTEPS.times do

      # ... control stuff that affects physics ...

      @space.step(@dt)
    end
  end

  def draw
    @background_image.draw(0,0,ZOrder::Background)
    @platform.draw
  end

  # Escape closes the game
  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end
end
