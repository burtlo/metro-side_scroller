class FirstScene < GameScene
  draw :fps, model: "metro::ui::fps", placement: 'bottom_right'

  draw :hero, position: Game.center

  draw :space, model: "metro::ui::space"

  draw :tile_map, model: "metro::ui::tile_map", file: "level.tmx", viewport: Game.bounds


  def show
    # TODO: this positioning business needs to be sorted out. When the map specifies a start
    # position for the player we should use that to center everything.
    # viewport.shift Point.at(tile_map.map.properties["viewport.left"].to_i,0)
    # viewport.shift Point.at(Game.center.x - hero.body.p.x,0)

    # TODO: it feels as though the tilemap should own the space and automatically add
    #   the objects.
    space.add_objects tile_map.objects("floor")
    space.add_object(hero)
    space.gravity_affects(hero)
  end


  def update
    original_position = hero.body.p.x

    space.step

    # TODO: by using an integer there is some slippage when a character moves less than a pixel
    distance = (hero.body.p.x - original_position).to_i
    tile_map.viewport.shift(Point.at(distance,0))

    space.clean_up
  end

end
