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
      :Objects => {:Platforms => Array.new},
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
  end

  def save(filename)
    File.open(filename, 'w') do |f|
      f.write(YAML::dump(@hash))
    end
  end

  def add_platform(x,y,image_loc)
    @hash[:Objects][:Platforms] << [x,y,image_loc]
  end

end
