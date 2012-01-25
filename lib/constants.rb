SCREEN_WIDTH = 800
SCREEN_HEIGHT = 600

WORLD_WIDTH = 1024
WORLD_HEIGHT = 768

CP_SUBSTEPS = 6

# media constants
MEDIA_DIR = "media"
IMAGES_DIR = "#{MEDIA_DIR}/images"
SOUNDS_DIR = "#{MEDIA_DIR}/sounds"
MUSIC_DIR = "#{MEDIA_DIR}/music"

module ZOrder
  Background, ParallaxFar, ParallaxNear, Objects, Player, ParallaxObstruct, HUD = *0..6
end
