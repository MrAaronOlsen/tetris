module Board
  class NextShape
    attr_reader :live_shape, :next_shape
    attr_reader :width, :height, :world_sides

    def initialize
      @frame_offset = Mat.new_translate(V.new(13.5, 3.5))
      @shape_offset = Mat.new_translate(V.new(0, 2)).add_translate(@frame_offset)
      @width, @height = 8, 5
      @bag = Array.new

      build
    end

    def get
      @live_shape = @next_shape || random_shape
      @next_shape = random_shape
      @live_shape
    end

    def build
      @world_sides = [V.new, V.new(@width, 0), V.new(@width, @height), V.new(0, @height)]
    end

    def get_world_sides(origin, scale)
      @world_sides.map { |side| scale.convert(origin.convert(side)) }
    end

    def random_shape
      fill_bag if @bag.empty?

      @bag.sample_and_remove.call(V.new(4, 1))
    end

    def fill_bag
      @bag = Shapes.factories
    end

    def draw(scale)
      @next_shape.draw(@shape_offset, scale) if @next_shape
      Render.rect(get_world_sides(@frame_offset, scale), Colors.grey.get, false, 1)
    end
  end
end