class Hero < Metro::UI::Sprite
  property :image, path: "hero.png"

  property :turn_amount, default: 80
  property :velocity, default: 4000

  property :position

  property :mass, default: 10
  property :moment_of_interia, default: 1000000

  def body
    @body ||= begin
      body = CP::Body.new(mass,moment_of_interia)
      body.p = CP::Vec2::ZERO
      body.v = CP::Vec2::ZERO
      body.a = 0
      body
    end
  end

  def shape
    @shape ||= begin
      poly_array = [ CP::Vec2.new(-28.0, -28.0), CP::Vec2.new(-28.0, 28.0), CP::Vec2.new(28.0, 28.0), CP::Vec2.new(28.0, -28.0)]
      new_shape = CP::Shape::Poly.new(body,poly_array, CP::Vec2::ZERO)
      new_shape.collision_type = :hero
      new_shape.e = 0.0
      new_shape
    end
  end


  event :on_hold, KbLeft, GpLeft do
    body.apply_impulse(CP::Vec2.new(-40,0),CP::Vec2.new(0.0, 0.0))
  end

  event :on_hold, KbRight, GpRight do
    body.apply_impulse(CP::Vec2.new(40,0),CP::Vec2.new(0.0, 0.0))
  end

  event :on_hold, KbDown, GpDown do
  end

  event :on_up, KbSpace do
    body.apply_impulse(CP::Vec2.new(0,-2000),CP::Vec2.new(0.0, 0.0))
  end

  def show
    body.p = CP::Vec2.new(x,y)
  end

  def draw
    # puts body.v.to_s
    # dim = Dimensions.of(shape.bb.r - shape.bb.l,shape.bb.b - shape.bb.t)
    # border = create "metro::ui::border", position: Point.at(shape.bb.l,shape.bb.t), dimensions: dim
    # border.draw
    dangle = body.a.to_degrees

    hero_x = body.p.x - scene.viewport.left
    hero_y = body.p.y - scene.viewport.top
    image.draw_rot(hero_x,hero_y,z_order,dangle)
  end

end