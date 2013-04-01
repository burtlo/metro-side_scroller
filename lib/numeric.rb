class Numeric
  def radians_to_vec2
    CP::Vec2.new(Math::cos(self), Math::sin(self))
  end

  def to_degrees
    self * 180 / Math::PI
  end

  def to_radians
    self * Math::PI / 180
  end
end