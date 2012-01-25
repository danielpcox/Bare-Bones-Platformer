# keeps track of the viewing window within the larger world
class Camera
  attr_accessor :x, :y

  def initialize(x, y)
    @x = x.to_f, @y = y.to_f
  end

  def world_to_screen(world_coords)
    world_coords - self.to_vec2
  end

  def screen_to_world(screen_coords)
    self.to_vec2 + screen_coords
  end

  def to_vec2
    CP::Vec2.new(self.x, self.y)
  end

  def to_a
    [x, y]
  end
end
