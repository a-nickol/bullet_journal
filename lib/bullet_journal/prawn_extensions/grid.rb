module Grid
  def create_grid x, y
    x.times do |i|
      y.times do |j|
        bounding_box([bounds.width / x * i, bounds.height / y * (j + 1)], :width => bounds.width / x, :height => bounds.height / y ) do
          yield i, j
        end
      end
    end
  end
end

