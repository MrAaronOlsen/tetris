class Game < Gosu::Window

	def initialize
    @width = 800
    @height = 800

    super(@width, @height, false)
    self.caption = "Tetris"

    @scale = Mat.new_scale(@width / 24, @width / 24)
    @arbiter = Board::Arbiter.new
 	end

	def update
		@arbiter.update
	end

	def draw
		@arbiter.draw(@scale)
	end

	def button_down(key)
		@arbiter.query(key)

		close if key == Gosu::KbEscape
	end
end