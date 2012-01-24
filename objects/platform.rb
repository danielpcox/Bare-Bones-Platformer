# creates a single platform
class Platform
  def initialize(window, x, y, image_loc = "media/dirtblocks.png")
    space = window.space
    @tileset = Gosu::Image.load_tiles(window, image_loc, 60, 60, true)

    h = @tileset[0].height
    w = @tileset[0].width
    mass = h * w
    #shape_array = [CP::Vec2.new(-hh, -hw), CP::Vec2.new(-hh, hw), CP::Vec2.new(hh, hw), CP::Vec2.new(hh, -hw)]
    shape_array = [CP::Vec2.new(0,0), CP::Vec2.new(0, w), CP::Vec2.new(h, w), CP::Vec2.new(h, 0)]
    #@body = CP::Body.new(mass, CP.moment_for_poly(mass, shape_array, CP::Vec2.new(0,0)))
    @body = CP::Body.new_static()
    @body.p = CP::Vec2.new(x, y)
    shape = CP::Shape::Poly.new(@body, shape_array, CP::Vec2.new(0,0))
    shape.collision_type = :platform

    #space.add_body(@body)
    space.add_shape(shape)
  end

  def draw(camera)
    @tileset[0].draw(*camera.world_to_screen(CP::Vec2.new(@body.p.x, @body.p.y)).to_a, ZOrder::Objects)
  end
end
