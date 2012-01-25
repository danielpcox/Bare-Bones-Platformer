# creates a single platform
class Platform
  def initialize(window, x, y, image_filename = "dirtblocks.png")
    @image_filename = image_filename
    space = window.space
    
    # TODO : make my own platforms with a single image
    @tileset = Gosu::Image.load_tiles(window, "#{IMAGES_DIR}/#{image_filename}", 60, 60, true)

    # create shape and body and add shape to space
    h = @tileset[0].height
    w = @tileset[0].width
    shape_array = [CP::Vec2.new(0,0), CP::Vec2.new(0, w), CP::Vec2.new(h, w), CP::Vec2.new(h, 0)]
    @body = CP::Body.new_static()
    @body.p = CP::Vec2.new(x, y)
    @body.object = self # set user-definable object field to be this Platform object
    shape = CP::Shape::Poly.new(@body, shape_array, CP::Vec2.new(0,0))
    shape.collision_type = :platform
    space.add_shape(shape)
  end

  def draw(camera)
    @tileset[0].draw(*camera.world_to_screen(CP::Vec2.new(@body.p.x, @body.p.y)).to_a, ZOrder::Objects)
  end

  def to_a
    [@body.p.x.to_i, @body.p.y.to_i, @image_filename]
  end
end
