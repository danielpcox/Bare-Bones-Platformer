require 'gosu'
require 'chipmunk'

require './objects/player'
require './objects/walls'
require './objects/platform'

require './lib/constants'
require './lib/utility'
require './lib/camera'
require './lib/level'
include Utility

class GameWindow < Gosu::Window
  attr_accessor :space, :platforms, :background_image
  def initialize
    super SCREEN_WIDTH, SCREEN_HEIGHT, false
    self.caption = "Project Fantastic"
    @background_image = Gosu::Image.new(self, "media/background.png", true)
    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)

    # Time increment over which to apply a physics step
    @dt = (1.0/60.0)

    # Chipmunk space setup
    @space = CP::Space.new
    #@space.gravity = Vec2.new(0.0, 9.8)
    @space.gravity = Vec2.new(0.0, 19.6)

    # camera setup
    @camera = Camera.new(0,0)

    # create walls
    Walls.new(self, WORLD_WIDTH, WORLD_HEIGHT)

    # create player
    @player = Player.new(self, 0, 0)


    @level = Level.new

    # create platforms
    @platforms = Array.new
    @level.load(self, "levels/sandbox.yml")

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

    if (@player.body.p.y - SCREEN_HEIGHT / 2 < 0)
      @camera.y = 0
    elsif (@player.body.p.y + SCREEN_HEIGHT / 2 > WORLD_HEIGHT)
      @camera.y = WORLD_HEIGHT - SCREEN_HEIGHT
    else
      @camera.y = @player.body.p.y - SCREEN_HEIGHT / 2
    end

    CP_SUBSTEPS.times do

      # ... control stuff that affects physics ...
      @player.update(Gosu::milliseconds,(button_down? Gosu::KbLeft), (button_down? Gosu::KbRight), (button_down? Gosu::KbUp))
      @shape_pos = @space.point_query_first(CP::Vec2.new(mouse_x, mouse_y), CP::ALL_LAYERS, CP::NO_GROUP)

      @space.step(@dt)
    end
  end

  def draw
    @background_image.draw(*@camera.world_to_screen(CP::Vec2.new(0,0)).to_a,ZOrder::Background)
    @platforms.each {|p| p.draw(@camera) }
    @player.draw(@camera)
    @font.draw("Object Position: #{@shape_pos.to_s}", 10, 10, ZOrder::HUD, 1.0, 1.0, 0xffffff00)
  end

  # Escape closes the game
  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end
end
