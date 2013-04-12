module Metro
  module UI
    class Space < Model

      property :damping, default: 0.5
      property :sampling_per_update, default: 6

      def delta
        @delta ||= (1.0/60.0)
      end

      def gravitational_forces
        [ CP::Vec2.new(0,1000), CP::Vec2.new(0,0) ]
      end

      attr_reader :space

      def show
        @space = CP::Space.new
        @space.damping = damping
      end

      def update
        apply_gravity_to victims_of_gravity
      end

      def add_object(object)
        space_objects.push(object)
        space.add_body object.body
        space.add_shape object.shape
      end

      def space_objects
        @space_objects ||= []
      end

      def add_objects(objects)
        Array(objects).each {|object| add_object(object) }
      end

      def step
        sampling_per_update.to_i.times { space.step(delta) }
      end

      def clean_up
        space_objects.each {|object| object.body.reset_forces }
        space.rehash_static
      end

      def victims_of_gravity
        @victims_of_gravity ||= []
      end

      def gravity_affects(object)
        victims_of_gravity.push object
      end

      def apply_gravity_to(objects)
        objects.each {|object| object.body.apply_force *gravitational_forces }
      end

    end
  end
end
