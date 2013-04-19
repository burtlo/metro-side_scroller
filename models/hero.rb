class Hero < Metro::UI::Sprite
  property :image, path: "hero.png"

  property :walking, type: :animation, path: "hero-walking.png",
    dimensions: Dimensions.of(128,128), time_per_image: 33

  property :turn_amount, default: 80
  property :velocity, default: 4000

  property :scale, default: "1.0,1.0"

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
      poly_array = [ CP::Vec2.new(-48.0, -48.0), CP::Vec2.new(-48.0, 48.0), CP::Vec2.new(48.0, 48.0), CP::Vec2.new(48.0, -48.0)]
      new_shape = CP::Shape::Poly.new(body,poly_array, CP::Vec2::ZERO)
      new_shape.collision_type = :hero
      new_shape.e = 0.0
      new_shape
    end
  end


  event :on_hold, KbLeft, GpLeft do
    body.apply_impulse(CP::Vec2.new(-40,0),CP::Vec2.new(0.0, 0.0))
    # flip left
    start_walking
  end

  event :on_hold, KbRight, GpRight do
    body.apply_impulse(CP::Vec2.new(40,0),CP::Vec2.new(0.0, 0.0))
    # flip left
    start_walking
  end

  event :on_up, KbRight, GpRight do
    stop_walking
  end

  event :on_up, KbLeft, GpLeft do
    stop_walking
  end

  event :on_hold, KbDown, GpDown do
  end

  event :on_up, KbSpace do
    body.apply_impulse(CP::Vec2.new(0,-2000),CP::Vec2.new(0.0, 0.0))
    # change to animated jumping
  end

  def show
    body.p = CP::Vec2.new(x,y)
  end

  def current_image
    if walking?
      walking.image
    else
      image
    end
  end

  def start_walking
    @walking = true
  end

  def stop_walking
    @walking = false
  end

  def walking?
    @walking
  end

  def draw
    dangle = body.a.to_degrees

    self.x = body.p.x - scene.tile_map.viewport.left
    self.y = body.p.y - scene.tile_map.viewport.top
    current_image.draw_rot(x,y,z_order,dangle)

    # dim = Dimensions.of(shape.bb.r - shape.bb.l,shape.bb.b - shape.bb.t)
    # border = create "metro::ui::border", position: Point.at(hero_x - 48,shape.bb.t), dimensions: dim
    # border.draw

  end

end