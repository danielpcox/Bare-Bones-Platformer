class Background
  def initialize(window, x, y, image_filename, zorder)
    @image = Gosu::Image.new(window, "#{BACKGROUNDS_DIR}/#{image_filename}", true)
    @pos = CP::Vec2.new(x,y)
    @zorder = zorder
  end

  def draw(camera)
    @image.draw(*camera.x_parallax_world_to_screen(@pos, @zorder+1).to_a, @zorder)
  end

  def to_a
    []
  end
end
