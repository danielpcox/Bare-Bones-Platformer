class Player
  attr_reader :body

  @@off_ground = false
  def self.off_ground=(val)
    @@off_ground = val
  end
  def self.off_ground
    @@off_ground
  end

  def initialize(window, x, y)
    space = window.space

    # init direction he's facing
    @facing_dir = :right

    # init wow sound for jumps
    @wow = Gosu::Sample.new(window, "#{SOUNDS_DIR}/wow.wav")

    # Load all animation frames
    @standing, @walk1, @walk2, @jump =
      *Gosu::Image.load_tiles(window, "#{IMAGES_DIR}/player.png", 50, 50, false)

    # the current image depends on his activity
    @cur_image = @standing

    # create physical properties and add to space
    mass = @standing.height * @standing.width / MASS_DIVIDER
    @body = CP::Body.new(mass, CP::INFINITY)
    @body.object = self # user-defined object is this Player
    @body.p = CP::Vec2.new(x, y)
    @body.v_limit = PLAYER_MAX_V
    shape = CP::Shape::Circle.new(@body, 25.0, CP::Vec2.new(0.0,0.0))
    shape.u = 0.5 # friction coefficient
    shape.e = 0.0 # elasticity
    shape.collision_type = :player
    space.add_body(@body)
    space.add_shape(shape)

    #ground sensor:
    ground_sensor = CP::Shape::Circle.new(@body, 3.0, CP::Vec2.new(0.0,25.0))
    ground_sensor.sensor = true
    ground_sensor.collision_type = :ground_sensor 
    space.add_shape(ground_sensor)

    # setup ground sensor collision handlers
    space.add_collision_handler(:ground_sensor, :wall, GSCollisionHandler.new)
    space.add_collision_handler(:ground_sensor, :platform, GSCollisionHandler.new)
  end

  class GSCollisionHandler
    def begin(a,b,arb)
      Player.off_ground = false
    end
    def separate
      Player.off_ground = true
    end
  end

  def go_left
    if Player.off_ground
      @body.apply_force(CP::Vec2.new(-IN_AIR_X_FORCE, 0.0),CP::Vec2.new(0,0.0))
    else
      @body.apply_force(CP::Vec2.new(-ON_GROUND_X_FORCE, 0.0),CP::Vec2.new(0,0.0))
    end
  end

  def spin_around_left
    @body.apply_force(CP::Vec2.new(-SPIN_AROUND_FORCE, 0.0),CP::Vec2.new(0,0.0))
  end

  def go_right
    if Player.off_ground
      @body.apply_force(CP::Vec2.new(IN_AIR_X_FORCE, 0.0),CP::Vec2.new(0,0.0))
    else
      @body.apply_force(CP::Vec2.new(ON_GROUND_X_FORCE, 0.0),CP::Vec2.new(0,0.0))
    end
  end

  def spin_around_right
    @body.apply_force(CP::Vec2.new(SPIN_AROUND_FORCE, 0.0),CP::Vec2.new(0,0.0))
  end

  def go_up
    @body.apply_impulse(CP::Vec2.new(0.0, -JUMP_IMPULSE), CP::Vec2.new(0,0))
  end

  def update(milliseconds, left_pressed, right_pressed, up_pressed)
    if (@body.v.x.abs < VX_MARGIN_CUT_TO_ZERO)
      @cur_image = @standing
    else
      @cur_image = (milliseconds / ANIM_DIVISOR % 2 == 0) ? @walk1 : @walk2
    end

    if (Player.off_ground)
      @cur_image = @jump
    end

    going_left = (@body.v.x < 0)
    @body.reset_forces
    if left_pressed
      @facing_dir = :left
      if !going_left
        spin_around_left
      else
        go_left
      end
    end
    if right_pressed
      @facing_dir = :right
      if going_left
        spin_around_right
      else
        go_right
      end
    end
    if up_pressed && !Player.off_ground
      if !@up_still_pressed
        @wow.play(0.5, 1.4)
        @up_still_pressed = true
      end
      go_up
    end
    @up_still_pressed = false if !up_pressed


    if !left_pressed && !right_pressed
      @body.v += CP::Vec2.new(-@body.v.x / 100, 0.0)
      @body.v.x = 0.0 if @body.v.x.abs < 2.0
    end
  end
  
  def draw(camera)
    if @facing_dir == :left then
      factor = 1.0
    else
      factor = -1.0
    end
    @cur_image.draw_rot(*camera.world_to_screen(CP::Vec2.new(@body.p.x, @body.p.y)).to_a, ZOrder::Player, @body.a, 0.5, 0.5, factor)
  end
  
end

