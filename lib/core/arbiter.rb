class Arbiter

  class << self

    def check_rotation(shape, direction)
      next_state = get_next_state(shape.state, direction)
      next_angle = next_state * 90
      kick_offset = get_kick_offset_for(shape.type)
      next_pos = nil

      Array(0..kick_offset[0].size - 1).each do |i|
        kick = kick_offset[shape.state][i] - kick_offset[next_state][i]

        next_pos = shape.pos + kick
        next_transform = Mat.new_transform(next_pos, next_angle)

        if colliding(shape, next_transform)
          next_pos = shape.pos - kick
          next_transform = Mat.new_transform(next_pos, next_angle)

          break unless colliding(shape, next_transform)
        else
          break
        end
      end

      shape.pos = next_pos
      shape.state = next_state
      shape.set_transform
    end

    def check_position(shape, direction)
      next_pos = get_next_position(shape.pos, direction)
      next_trans = Mat.new_transform(next_pos, shape.get_angle)

      if !colliding(shape, next_trans)
        shape.pos = next_pos
        shape.set_transform
      end
    end

    def colliding(shape, next_trans)
      shape.get_block_positions(next_trans).each do |pos|
        return true if pos.x < 0 || pos.x > 9
      end

      false
    end

    def get_next_state(current_state, direction)
      next_state = (current_state + direction) % 4
      next_state += 3 if next_state < 0
      next_state
    end

    def get_next_position(current_position, direction)
      current_position + direction
    end

    def kick_offset_JLSZT
      [ [ V.new( 0, 0), V.new( 0, 0),	V.new( 0, 0),	V.new( 0, 0),	V.new( 0, 0) ],
        [ V.new( 0, 0),	V.new( 1, 0),	V.new( 1, 1),	V.new( 0,-2),	V.new( 1,-2) ],
        [ V.new( 0, 0),	V.new( 0, 0),	V.new( 0, 0),	V.new( 0, 0),	V.new( 0, 0) ],
        [	V.new( 0, 0), V.new(-1, 0),	V.new(-1, 1),	V.new( 0,-2),	V.new(-1,-2) ] ]
    end

    def kick_offset_I
      [ [ V.new( 0, 0),	V.new(-1, 0),	V.new( 2, 0),	V.new(-1, 0),	V.new( 2, 0) ],
        [ V.new(-1, 0),	V.new( 0, 0),	V.new( 0, 0),	V.new( 0,-1),	V.new( 0, 2) ],
        [ V.new(-1,-1),	V.new( 1,-1),	V.new(-2,-1),	V.new( 1, 0),	V.new(-2, 0) ],
        [ V.new( 0,-1),	V.new( 0,-1),	V.new( 0,-1),	V.new( 0, 1),	V.new( 0,-2) ] ]
    end

    def kick_offset_O
      [ [ V.new( 0, 0) ],
        [ V.new(-1, 0) ],
        [ V.new(-1,-1) ],
        [ V.new( 0,-1) ] ]
    end

    def get_kick_offset_for(type)
      case type
      when "I"
        kick_offset_I
      when "O"
        kick_offset_O
      when "J", "L", "S", "Z", "T"
        kick_offset_JLSZT
      end
    end
  end
end