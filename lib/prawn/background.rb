module Background
  def dotted_background
    fill_color $gray
    x = 0
    while x < bounds.width
      y = 0
      while y < bounds.height
        fill_circle [x, y], 0.5
        y += 5.mm
      end
      x += 5.mm
    end
    fill_color $black
  end
end

