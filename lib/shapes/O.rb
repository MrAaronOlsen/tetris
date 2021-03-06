class Shape
  # O X X
  # O X X
  # O O O

  class O < Shape
    def initialize(pos)
      @type = "O"
      @pos = pos
      @angle = 0
      @color = get_color

      build
    end

    def get_color
      Colors.yellow
    end

    def shape_map
      [ V.new(0, 0), V.new(0, -1), V.new(1, -1), V.new(1, 0) ]
    end
  end
end