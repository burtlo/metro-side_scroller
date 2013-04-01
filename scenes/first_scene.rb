class FirstScene < GameScene
  draw :fps, model: "metro::ui::fps", placement: 'bottom_right'

  draw :rock, position: (Game.center + Point.at(0,200))

  draw :hero, position: Game.center

  def space
    @space ||= begin
      s = CP::Space.new
      s.damping = 0.4
      s.gravity = CP::Vec2.new(0,50)
      s
    end
  end

  def show
    CP.collision_slop = 0.1
    # CP.bias_coef = 0.1
    space.add_body hero.body
    space.add_shape hero.shape
    space.add_static_shape rock.shape
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
