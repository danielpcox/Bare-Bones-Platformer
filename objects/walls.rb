# creates the walls that prevent the player from exiting the world
class Walls
  PADDING = 10.0 # amount the wall hangs off the edge of the screen
  THICKNESS = 0.05

  def initialize(window, width, height)
    space = window.space

    # bottom wall
    wall_shape = CP::Shape::Segment.new(CP::Body.new_static(), CP::Vec2.new(0.0-PADDING, height), CP::Vec2.new(width+PADDING, height), THICKNESS)
    wall_shape.collision_type = :wall
    space.add_shape(wall_shape)

    # left wall
    wall_shape = CP::Shape::Segment.new(CP::Body.new_static(), CP::Vec2.new(0.0, height+PADDING), CP::Vec2.new(0.0, 0.0-PADDING), THICKNESS) 
    wall_shape.collision_type = :wall
    space.add_shape(wall_shape)


    # right wall
    wall_shape = CP::Shape::Segment.new(CP::Body.new_static(), CP::Vec2.new(width, height+PADDING), CP::Vec2.new(width, 0.0-PADDING), THICKNESS)
    wall_shape.collision_type = :wall
    space.add_shape(wall_shape)

    # top wall
    wall_shape = CP::Shape::Segment.new(CP::Body.new_static(), CP::Vec2.new(0.0-PADDING, 0.0), CP::Vec2.new(width+PADDING, 0.0), THICKNESS) 
    wall_shape.collision_type = :wall
    space.add_shape(wall_shape)

    # walls cannot bump into each other
    space.add_collision_func(:wall, :wall, &nil)
  end
end
