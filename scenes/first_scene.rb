class FirstScene < GameScene
  draw :fps, model: "metro::ui::fps", placement: 'bottom_right'

  # BUG: https://github.com/burtlo/metro/issues/4
  # draw :hero, position: Game.center
  draw :hero, position: "400,300"

  draw :tile_map, model: "metro::ui::tile_map", file: "level.tmx",
    # BUG: https://github.com/burtlo/metro/issues/4
    viewport: Metro::Units::RectangleBounds.new(left: 0, right: 800, top: 0, bottom: 600)

  def space
    @space ||= begin
      s = CP::Space.new
      s.damping = 0.5
      s
    end
  end

  # def world_shapes
  #   @world_shapes ||= []
  # end

  def add_objects(objects)
    Array(objects).each {|object| add_object(object) }
  end

  def add_object(object)
    # world_shapes.push object.poly_shape
    space.add_body object.body
    space.add_static_shape object.poly_shape
  end

  def show
    # TODO: this positoning business needs to be sorted out. When the map specifies a start
    # position for the player we should use that to center everything.
    # viewport.shift Point.at(tile_map.map.properties["viewport.left"].to_i,0)
    # viewport.shift Point.at(Game.center.x - hero.body.p.x,0)

    add_objects tile_map.objects("floor")

    CP.collision_slop = 0.1
    space.add_body hero.body
    space.add_shape hero.shape
  end

  def delta
    @delta ||= (1.0/60.0)
  end

  def space_collision_sampling
    6
  end

  def gravitational_forces
    [ CP::Vec2.new(0,1000), CP::Vec2.new(0,0) ]
  end

  def apply_gravity_to(object)
    object.body.apply_force *gravitational_forces
  end

  def update
    original_position = hero.body.p.x
    apply_gravity_to hero

    space_collision_sampling.times { space.step(delta) }

    distance = (hero.body.p.x - original_position).to_i
    tile_map.viewport.shift(Point.at(distance,0))

    hero.body.reset_forces
    space.rehash_static
  end

  def draw
    # world_shapes.each do |shape|
    #   x_position = shape.bb.r - shape.bb.l
    #   y_position = shape.bb.b - shape.bb.t

    #   position_at = Point.at(shape.bb.l - tile_map.viewport.left,shape.bb.t - tile_map.viewport.top)

    #   # dim = Dimensions.of(x_position,y_position)
    #   # # using the hero to create the borders is because I don't have a good way to do it in the scene object
    #   # border = hero.create "metro::ui::border", position: position_at, dimensions: dim
    #   # border.draw
    # end
  end

end
