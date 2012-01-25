require 'yaml'

# Potential Level Structure:
# - :Objects
#   - Platform
#   - Walls
# - :Meta
#   - player_pos
#   - background
#   - world_width
#   - world_height
#   - cut_scene
# - :Abilities
#   - fly
#   - gravity
class Level
  attr_accessor :hash

  def initialize
    @hash = {
      :Objects => {:Platforms => Array.new, :Backgrounds => Array.new},
      :Meta => {}
    }
  end

  def load(window, filename)
    File.open(filename, 'r') do |f|
      @hash = YAML::load(f.read)
    end

    # create platforms based on specs in @hash and add to space
    @hash[:Objects][:Platforms].each do |p|
      window.platforms << Platform.new(window, *p)
    end

    # create background objects based on specs in @hash
    @hash[:Objects][:Backgrounds].each do |b|
      window.backgrounds << Background.new(window, *b)
    end
    #window.backgrounds << Background.new(window, 0, 0, "background.png", ZOrder::ParallaxFar)
    #window.backgrounds << Background.new(window, 200, 500, "vine.png", ZOrder::ParallaxNear)
  end

  def save(filename)
    File.open(filename, 'w') do |f|
      f.write(YAML::dump(@hash))
    end
  end

  def add_platform(platform)
    @hash[:Objects][:Platforms] << platform.to_a
  end

  def add_background(background)
    @hash[:Objects][:Backgrounds] << background.to_a
  end

end
