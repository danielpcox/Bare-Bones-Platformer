class Mouse
  def initialize(window)
    @cursor = Gosu::Image.new(window, "#{IMAGES_DIR}/cursor.png", false)
  end

  def draw(mouse_x, mouse_y)
    @cursor.draw(mouse_x, mouse_y, ZOrder::HUD)
  end
end
