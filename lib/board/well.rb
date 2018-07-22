module Board
  class Well
    attr_reader :width, :height
    attr_reader :grid, :offset
    attr_reader :live_shape

    def initialize
      @width, @height = 10, 16
      @offset = Mat.new_translate(V.new(5, 4))
      @grid = Grid.new(@width, @height)
      @shaper = Shaper.new
    end

    def spawn_shape
      @live_shape = @shaper.get_next
    end

    def reset_shape(shape)
      @live_shape = @shaper.shapes[shape].call(V.new(4, 1))
    end

    def clear
      @grid.clear
      @live_shape = nil
    end

    def freeze_live_shape
      @grid.add_shape(@live_shape)
      check_for_complete_rows

      @live_shape = nil
    end

    def has_block_at(pos)
      @grid.rows[pos.y].cells[pos.x].has_block?
    end

    def check_for_complete_rows
      rows_to_drop = []
      last_row = nil

      @grid.rows.reverse.each do |row|
        if row.complete?
          row.clear

          rows_to_drop << row
          last_row = row
        end
      end

      return if last_row.nil?
      remove_rows(rows_to_drop)
    end

    def remove_rows(rows_to_drop)
      rows_to_drop.each_with_index do |row_removed, i|

        @grid.rows.reverse.each do |row|
          next if row.number >= row_removed.number + i

          row.cells.each do |cell|
            row_to_drop_into = @grid.rows[row.number + 1]
            row_to_drop_into.cells[cell.x].add_block(cell.block)
            cell.clear_block
          end
        end
      end
    end

    def draw(scale)
      @grid.draw(@offset, scale)
      @shaper.draw(scale)
      @live_shape.draw(@offset, scale) if @live_shape
    end
  end
end
