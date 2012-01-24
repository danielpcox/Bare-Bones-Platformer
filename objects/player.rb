class Player
  PLAYER_MAX_V = 100.0

  attr_reader :body

  def initialize(window, x, y)
    space = window.space

    # direction he's facing
    @dir = :right

    # Load all animation frames
    @standing, @walk1, @walk2, @jump =
      *Gosu::Image.load_tiles(window, "media/player.png", 50, 50, false)

    h = @standing.height
    w = @standing.width
    mass = h * w / 1000
    @body = CP::Body.new(mass, CP::INFINITY)
    @body.p = CP::Vec2.new(x, y)
    @body.v_limit = PLAYER_MAX_V
    shape = CP::Shape::Circle.new(@body, 25.0, CP::Vec2.new(0.0,0.0))
    shape.u = 0.9 # friction coefficient
    shape.e = 0.0 # elasticity
    shape.collision_type = :player

    space.add_body(@body)
    space.add_shape(shape)

  end

  def go_left
    @body.apply_force(CP::Vec2.new(-50.0, 0.0),CP::Vec2.new(0,0.0))
  end

  def spin_around_left
    @body.apply_force(CP::Vec2.new(-110.0, 0.0),CP::Vec2.new(0,0.0))
  end

  def go_right
    @body.apply_force(CP::Vec2.new(50.0, 0.0),CP::Vec2.new(0,0))
  end

  def spin_around_right
    @body.apply_force(CP::Vec2.new(110.0, 0.0),CP::Vec2.new(0,0.0))
  end

  def go_up
    @body.apply_impulse(CP::Vec2.new(0.0, -200.0), CP::Vec2.new(0,0))
  end

  def update(left_pressed, right_pressed, up_pressed)
    going_left = (@body.v.x < 0)
    @body.reset_forces
    if left_pressed
      if !going_left
        spin_around_left
      else
        go_left
      end
    end
    if right_pressed
      if going_left
        spin_around_right
      else
        go_right
      end
    end
    if up_pressed && !@up_still_pressed
      go_up
      @up_still_pressed = true
    end
    @up_still_pressed = false if !up_pressed

    if !left_pressed && !right_pressed
      @body.v += CP::Vec2.new(-@body.v.x / 100, 0.0)
      @body.v.x = 0.0 if @body.v.x.abs < 2.0
    end
  end
  
  def draw(camera)
    @standing.draw_rot(*camera.world_to_screen(CP::Vec2.new(@body.p.x, @body.p.y)).to_a, ZOrder::Player, @body.a)
  end
  
end

