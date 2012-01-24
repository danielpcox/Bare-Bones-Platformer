class Player
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
    mass = h * w / 712 # TODO : remove magic numbers
    shape_array = [CP::Vec2.new(0,0), CP::Vec2.new(0, h), CP::Vec2.new(w, h), CP::Vec2.new(w, 0)]
    #shape_array = [CP::Vec2.new(-hh, -hw), CP::Vec2.new(-hh, hw), CP::Vec2.new(hh, hw), CP::Vec2.new(hh, -hw)]
    #CP::recenter_poly(shape_array)
    @body = CP::Body.new(mass, CP.moment_for_poly(mass, shape_array, CP::Vec2.new(0,0)))
    #@body = CP::Body.new_static()
    @body.p = CP::Vec2.new(x, y)
    shape = CP::Shape::Poly.new(@body, shape_array, CP::Vec2.new(-w/2,-h))
    #shape = CP::Shape::Poly.new(@body, shape_array, CP::Vec2.new(0,0))
    shape.collision_type = :platform

    space.add_body(@body)
    space.add_shape(shape)

    # This always points to the frame that is currently drawn.
    # This is set in update, and used in draw.
    @cur_image = @standing    
  end

  def left
    @body.apply_impulse(CP::Vec2.new(-100.0, 0.0),CP::Vec2.new(0,0.0))
  end

  def right
    @body.apply_impulse(CP::Vec2.new(100.0, 0.0),CP::Vec2.new(0,0))
  end

  def jump
    @body.apply_impulse(CP::Vec2.new(0.0, -200.0), CP::Vec2.new(0,0))
  end
  
  def draw(camera)
    # Flip vertically when facing to the left.
    if @dir == :left then
      offs_x = -25
      factor = 1.0
    else
      offs_x = 25
      factor = -1.0
    end
    @cur_image.draw(*camera.world_to_screen(CP::Vec2.new(@body.p.x + offs_x, @body.p.y - 49)).to_a, 0, factor, 1.0)
  end
  
end

