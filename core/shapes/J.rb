class Shape
  # O O X
  # X X X
  # O O O

  class J < Shape
    def initialize
      super
    end

    def get_blocks
      [ Block.new(-1, 0), Block.new(0, 0), Block.new(1, 0), Block.new(1, 1) ]
    end
  end
end