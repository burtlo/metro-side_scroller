class FirstScene < GameScene
  draw :fps, model: "metro::ui::fps", placement: 'bottom_right'

  # draw :rock, position: (Game.center + Point.at(0,200))

  draw :hero, position: Game.center

  draw :map, model: "metro::ui::tile_map",
    file: "level.tmx", position: "0,0,-1"

  event :on_hold, KbLeft, GpLeft do
    # body.t -= turn_amount
    puts "Scrolling world right"
  end

  event :on_hold, KbRight, GpRight do
    # body.t += turn_amount
    puts "Scrolling world left"
  end


  def space
    @space ||= begin
      s = CP::Space.new
      s.damping = 0.5
      s.gravity = CP::Vec2.new(0,150)
      s
    end
  end

  def viewport
    @viewport ||= Game.bounds
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

  def update
    6.times do
      space.step(delta)
    end
    hero.body.reset_forces
  end

end
