SCREEN_WIDTH = 800
SCREEN_HEIGHT = 600

WORLD_WIDTH = 1600
WORLD_HEIGHT = 768

# physics constants
CP_SUBSTEPS = 6
MASS_DIVIDER = 200

# camera constants
#CAMERA_BEHAVIOR = :stop_at_world_edge # or :free
CAMERA_BEHAVIOR = :free
PARALLAX_SEPARATION_FACTOR = 3.0

# player constants
PLAYER_MAX_V = 75.0
ANIM_DIVISOR = 175
JUMP_IMPULSE = 200.0
IN_AIR_X_FORCE = 100.0
ON_GROUND_X_FORCE = 200.0 
SPIN_AROUND_FORCE = 300.0 # force to apply when the player suddenly changes direction
VX_MARGIN_CUT_TO_ZERO = 5.0 # x velocity below which we'll just stop the player moving

# media constants
MEDIA_DIR = "media"
IMAGES_DIR = "#{MEDIA_DIR}/images"
SOUNDS_DIR = "#{MEDIA_DIR}/sounds"
MUSIC_DIR = "#{MEDIA_DIR}/music"
BACKGROUNDS_DIR = "#{IMAGES_DIR}/backgrounds"

module ZOrder
  Background, ParallaxFar, ParallaxNear, Objects, Player, ParallaxObstruct, HUD = *0..6
end
