class FirstScene < GameScene
  draw :fps, model: "metro::ui::fps", placement: 'bottom_right'

  # draw :rock, position: (Game.center + Point.at(0,200))

  draw :hero, position: Game.center

  draw :map, model: "metro::ui::tile_map",
    file: "level.tmx", position: "0,0,-1"

  def shift_bodies(vector)
    world_bodies.each do |body|
      body.p = CP::Vec2.new(body.p.x + vector.x,body.p.y + vector.y)
    end
  end


  def space
    @space ||= begin
      s = CP::Space.new
      s.damping = 0.5
      s
    end
  end

  def world_bodies
    @world_bodies ||= []
  end

  def world_shapes
    @world_shapes ||= []
  end

  def show
    map.viewport = viewport
    map.show

    layer = map.layers.first

    object_group = map.map.object_groups.first
    floors = object_group.objects.find_all {|object| object.type == "floor" }

    floors.each do |floor|
      floor.points

      body = CP::Body.new Float::INFINITY, Float::INFINITY

      points = floor.points.map do |point|
        x,y = point.split(",").map {|p| p.to_i }
        CP::Vec2.new(x,y)
      end

      new_shape = CP::Shape::Poly.new(body,points.reverse, CP::Vec2::ZERO)
      new_shape.collision_type = :rock
      new_shape.e = 0.0

      world_bodies.push body
      world_shapes.push new_shape

      space.add_body body
      space.add_static_shape new_shape
    end

    CP.collision_slop = 0.1
    space.add_body hero.body
    space.add_shape hero.shape
  end

  def blocking_image_indexes
    @blocking_image_indexes ||= [ 1 ]
  end


  def delta
    @delta ||= (1.0/60.0)
  end

  def viewport
    @viewport ||= Game.bounds
  end

  def update
    original_position = hero.body.p.x
    # gravity on just the hero
    hero.body.apply_force CP::Vec2.new(0,1000), CP::Vec2.new(0,0)
    6.times do
      space.step(delta)
    end

    distance = (hero.body.p.x - original_position).to_f
    viewport.shift(Point.at(distance,0))

    hero.body.reset_forces
    space.rehash_static
  end

  def draw
    world_shapes.each do |shape|
      x_position = shape.bb.r - shape.bb.l
      y_position = shape.bb.b - shape.bb.t

      position_at = Point.at(shape.bb.l - viewport.left,shape.bb.t - viewport.top)

      dim = Dimensions.of(x_position,y_position)
      border = hero.create "metro::ui::border", position: position_at, dimensions: dim
      border.draw
    end
  end

end
