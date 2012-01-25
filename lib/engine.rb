require 'gosu'
require 'chipmunk'

require './objects/player'
require './objects/walls'
require './objects/platform'

require './lib/constants'
require './lib/utility'
require './lib/camera'
require './lib/level'
require './lib/mouse'
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

    # setup mouse cursor
    @mouse = Mouse.new(self)

    @level = Level.new

    # create platforms
    @platforms = Array.new
    @level.load(self, "levels/sandbox.yml") # loads the platforms into @platforms

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

    # destroy platforms
    mouse_in_world = @camera.screen_to_world(CP::Vec2.new(mouse_x, mouse_y))
    doomed_shape = @space.point_query_first(mouse_in_world, CP::ALL_LAYERS, CP::NO_GROUP)
    @doomed_shape_pos = doomed_shape.body.p if doomed_shape
    if doomed_shape && !(doomed_shape.body.object.is_a? Player) && (button_down? Gosu::MsRight) && !@still_clicking_right
      @space.remove_body(doomed_shape.body)
      @space.remove_shape(doomed_shape)
      @platforms.delete(doomed_shape.body.object)
      @level.hash[:Objects][:Platforms].delete_if do |p| 
        p[0]==doomed_shape.body.p.x && p[1]==doomed_shape.body.p.y
      end
      @level_edited = true
      @still_clicking_right = true
    elsif !(button_down? Gosu::MsRight)
      @still_clicking_right = false
    end
    # create platforms
    if (button_down? Gosu::MsLeft) && !@still_clicking_left
      platform_spec = [mouse_in_world.x, mouse_in_world.y, "media/dirtblocks.png"]
      @platforms << Platform.new(self, *platform_spec)
      @level.hash[:Objects][:Platforms] << platform_spec
      @level_edited = true
      @still_clicking_left = true
    elsif !(button_down? Gosu::MsLeft)
      @still_clicking_left = false
    end

    CP_SUBSTEPS.times do

      # ... control stuff that affects physics ...
      @player.update(Gosu::milliseconds,(button_down? Gosu::KbLeft), (button_down? Gosu::KbRight), (button_down? Gosu::KbUp))

      @space.step(@dt)
    end
  end

  def draw
    @background_image.draw(*@camera.world_to_screen(CP::Vec2.new(0,0)).to_a,ZOrder::Background)
    @platforms.each {|p| p.draw(@camera) }
    @player.draw(@camera)
    @mouse.draw(mouse_x, mouse_y)
    if @editing_mode
      @font.draw("Editing Mode On", 10, 10, ZOrder::HUD, 1.0, 1.0, 0xffffff00)
    end
  end

  # Escape closes the game
  def button_down(id)
    if id == Gosu::KbEscape
      @level.save("levels/sandbox.yml") if @level_edited
      close
    end
  end
end
