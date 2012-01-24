SCREEN_WIDTH = 800
SCREEN_HEIGHT = 600

WORLD_WIDTH = 1024
WORLD_HEIGHT = 768

CP_SUBSTEPS = 6


module ZOrder
  Background, ParallaxFar, ParallaxNear, Objects, Player, ParallaxObstruct, HUD = *0..5
end
