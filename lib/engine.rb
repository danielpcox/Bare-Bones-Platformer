require 'gosu'
require 'chipmunk'

require './objects/player'
require './objects/walls'
require './objects/platform'

require './lib/constants'
require './lib/utility'
require './lib/camera'
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
    @space.damping = 0.998

    # camera setup
    @camera = Camera.new(0,0)

    # create walls
    #Walls.new(self, SCREEN_WIDTH, SCREEN_HEIGHT)
    Walls.new(self, WORLD_WIDTH, WORLD_HEIGHT)

    # DEBUG : create a platform
    @platform = Platform.new(self, 300, 500, 'media/dirtblocks.png')

    @player = Player.new(self, 70, 500)
    @left = @right = @jump = false
  end

  def update
    # for each main update, we actually step the physics engine several times

    # ... control stuff that doesn't directly affect physics ...
    if (@player.body.p.x - SCREEN_WIDTH / 2 < 0)
      @camera.x = 0
    elsif (@player.body.p.x + SCREEN_WIDTH / 2 > WORLD_WIDTH)
      @camera.x = WORLD_WIDTH - SCREEN_WIDTH
    else
      @camera.x = @player.body.p.x - SCREEN_WIDTH / 2
    end

    CP_SUBSTEPS.times do

      # ... control stuff that affects physics ...
      if (button_down? Gosu::KbLeft) && !@left
        @player.left
        @left = true
      elsif !(button_down? Gosu::KbLeft) && @left
        @left = false
      end
      if (button_down? Gosu::KbRight) && !@right
        @player.right
        @right = true
      elsif !(button_down? Gosu::KbRight) && @right
        @right = false
      end
      if (button_down? Gosu::KbUp) && !@jump
        @player.jump
        @jump = true
      elsif !(button_down? Gosu::KbUp) && @jump
        @jump = false
      end

      @space.step(@dt)
    end
  end

  def draw
    @background_image.draw(*@camera.world_to_screen(CP::Vec2.new(0,0)).to_a,ZOrder::Background)
    @platform.draw(@camera)
    @player.draw(@camera)
  end

  # Escape closes the game
  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end
end
