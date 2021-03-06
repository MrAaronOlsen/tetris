module Menu
  class Scene
    attr_reader :frame

    def initialize(game)
      @game = game
      @frame = Frame.new
      @contents = Contents.new
      @controller = Controller.new

      @tick = Tick.new(1)
    end

    def update
      if @tick.go?
        @contents.rotate_selected_shape
      end

      @frame.update
    end

    def draw(scale)
      @frame.draw(scale)
      @contents.draw(scale)
    end

    def move_selection(direction)
      @contents.move(direction)
    end

    def trigger_action
      action =  @contents.selection

      @contents.show_scores(true) if action == 1
      @game.new_game if action == 0
      @game.close if action == 2
    end

    def return_to_menu
      @contents.show_menu
    end

    def game_over(score)
      @contents.game_over(score)
    end

    def query_key(key)
      @controller.query(key, self)
    end
  end
end