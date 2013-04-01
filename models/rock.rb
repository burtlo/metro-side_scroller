class Rock < Metro::UI::Sprite
  property :image, path: "rock.png"
  # property :mass, default: 1000
  # property :moment_of_interia, default: 10

  property :position

  def body
    @body ||= begin
      body = CP::Body.new Float::INFINITY, Float::INFINITY
      body.p = CP::Vec2::ZERO
      body.v = CP::Vec2::ZERO
      body.a = 0
      body
    end
  end

  def shape
    @shape ||= begin
      poly_array = [ CP::Vec2.new(-128.0, -64.0), CP::Vec2.new(-128.0, 64.0), CP::Vec2.new(128.0, 64.0), CP::Vec2.new(128.0, -64.0)]
      new_shape = CP::Shape::Poly.new(body,poly_array, CP::Vec2::ZERO)
      new_shape.collision_type = :rock
      new_shape.e = 0.0
      new_shape
    end
  end


  def show
    body.p = CP::Vec2.new(x,y)
  end

  def draw
    # puts body.v.to_s
    dim = Dimensions.of(shape.bb.r - shape.bb.l,shape.bb.b - shape.bb.t)
    border = create "metro::ui::border", position: Point.at(shape.bb.l,shape.bb.t,999), dimensions: dim
    border.draw
    dangle = body.a.to_degrees
    image.draw_rot(body.p.x,body.p.y,z_order,dangle)
  end

end