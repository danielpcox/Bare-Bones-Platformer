class Player
  @@off_ground = false
  def self.off_ground=(val)
    @@off_ground = val
  end
  def self.off_ground
    @@off_ground
  end

  PLAYER_MAX_V = 75.0

  attr_reader :body

  def initialize(window, x, y)
    space = window.space

    # direction he's facing
    @dir = :right

    # Load all animation frames
    @standing, @walk1, @walk2, @jump =
      *Gosu::Image.load_tiles(window, "media/player.png", 50, 50, false)
    @cur_image = @standing

    mass = @standing.height * @standing.width / 200
    @body = CP::Body.new(mass, CP::INFINITY)
    @body.p = CP::Vec2.new(x, y)
    @body.v_limit = PLAYER_MAX_V
    shape = CP::Shape::Circle.new(@body, 25.0, CP::Vec2.new(0.0,0.0))
    #ground sensor:
    ground_sensor = CP::Shape::Circle.new(@body, 2.0, CP::Vec2.new(0.0,25.0))
    ground_sensor.sensor = true
    shape.u = 0.5 # friction coefficient
    shape.e = 0.0 # elasticity
    shape.collision_type = :player
    ground_sensor.collision_type = :ground_sensor 

    space.add_body(@body)
    space.add_shape(shape)
    space.add_shape(ground_sensor)

    #space.add_collision_func(:ground_sensor, :wall) do
      #@on_ground = true
    #end

    space.add_collision_handler(:ground_sensor, :wall, CollisionHandler.new)
    space.add_collision_handler(:ground_sensor, :platform, CollisionHandler.new)

  end

  class CollisionHandler
    def begin(a,b,arb)
      Player.off_ground = false
    end
    def separate
      Player.off_ground = true
    end
  end

  def go_left
    if Player.off_ground
      @body.apply_force(CP::Vec2.new(-100.0, 0.0),CP::Vec2.new(0,0.0))
    else
      @body.apply_force(CP::Vec2.new(-200.0, 0.0),CP::Vec2.new(0,0.0))
    end
  end

  def spin_around_left
    @body.apply_force(CP::Vec2.new(-300.0, 0.0),CP::Vec2.new(0,0.0))
  end

  def go_right
    if Player.off_ground
      @body.apply_force(CP::Vec2.new(100.0, 0.0),CP::Vec2.new(0,0.0))
    else
      @body.apply_force(CP::Vec2.new(200.0, 0.0),CP::Vec2.new(0,0.0))
    end
  end

  def spin_around_right
    @body.apply_force(CP::Vec2.new(300.0, 0.0),CP::Vec2.new(0,0.0))
  end

  def go_up
    @body.apply_impulse(CP::Vec2.new(0.0, -200.0), CP::Vec2.new(0,0))
  end

  def update(milliseconds, left_pressed, right_pressed, up_pressed)
    if (@body.v.x.abs < 5.0)
      @cur_image = @standing
    else
      @cur_image = (milliseconds / 175 % 2 == 0) ? @walk1 : @walk2
    end

    if (Player.off_ground)
      @cur_image = @jump
    end

    going_left = (@body.v.x < 0)
    @body.reset_forces
    if left_pressed
      @dir = :left
      if !going_left
        spin_around_left
      else
        go_left
      end
    end
    if right_pressed
      @dir = :right
      if going_left
        spin_around_right
      else
        go_right
      end
    end
    if up_pressed && !Player.off_ground
      go_up
    end
    @dir = :up if Player.off_ground

    if !left_pressed && !right_pressed
      @body.v += CP::Vec2.new(-@body.v.x / 100, 0.0)
      @body.v.x = 0.0 if @body.v.x.abs < 2.0
    end
  end
  
  def draw(camera)
    if @dir == :left then
      factor = 1.0
    else
      factor = -1.0
    end
    @cur_image.draw_rot(*camera.world_to_screen(CP::Vec2.new(@body.p.x, @body.p.y)).to_a, ZOrder::Player, @body.a, 0.5, 0.5, factor)
  end
  
end

