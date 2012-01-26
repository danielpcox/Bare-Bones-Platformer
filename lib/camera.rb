# keeps track of the viewing window within the larger world
class Camera
  attr_accessor :x, :y, :parax, :paray

  def initialize(x, y)
    @x = x.to_f, @y = y.to_f
  end

  def world_to_screen(world_coords)
    world_coords - self.to_vec2
  end

  def screen_to_world(screen_coords)
    self.to_vec2 + screen_coords
  end

  def x_parallax_world_to_screen(world_coords, scroll_rate_offset)
    paraself = @parax ? CP::Vec2.new(@parax, @y) : CP::Vec2::ZERO
    screen_coords = world_coords - paraself
    CP::Vec2.new(screen_coords.x / (scroll_rate_offset * PARALLAX_SEPARATION_FACTOR), screen_coords.y)
  end

  def near_parallax(world_coords)
    paraself = @parax ? CP::Vec2.new(@parax, @paray) : CP::Vec2::ZERO
    world_coords - paraself
  end

  def to_vec2
    CP::Vec2.new(self.x, self.y)
  end

  def to_a
    [x, y]
  end
end
